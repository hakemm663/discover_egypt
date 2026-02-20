import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../constants/api_endpoints.dart';

class PaymentService {
  static const Duration _connectTimeout = Duration(seconds: 10);
  static const Duration _sendTimeout = Duration(seconds: 15);
  static const Duration _receiveTimeout = Duration(seconds: 15);
  static const int _maxRetryAttempts = 3;

  late final Dio _dio;

  PaymentService() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        headers: {'Content-Type': 'application/json'},
        connectTimeout: _connectTimeout,
        sendTimeout: _sendTimeout,
        receiveTimeout: _receiveTimeout,
      ),
    );

    dio.interceptors.addAll([
      _PaymentAuthInterceptor(),
      if (!kReleaseMode)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
        ),
      _PaymentRetryInterceptor(dio: dio, maxAttempts: _maxRetryAttempts),
    ]);

    _dio = dio;
  }

  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    required String customerId,
    String? description,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.createPaymentIntent,
        data: {
          'amount': (amount * 100).toInt(),
          'currency': currency.toLowerCase(),
          'description': description ?? 'Discover Egypt Booking',
          'customerId': customerId,
        },
      );
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (_) {
      throw const PaymentUnknownFailure(
        code: 'payment_intent_unexpected_error',
        message: 'We could not start your payment. Please try again.',
      );
    }
  }

  Future<void> initPaymentSheet({
    required String paymentIntentClientSecret,
    required String merchantDisplayName,
    String? customerId,
    String? customerEphemeralKeySecret,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: merchantDisplayName,
          customerId: customerId,
          customerEphemeralKeySecret: customerEphemeralKeySecret,
          style: ThemeMode.system,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(primary: Color(0xFFC89B3C)),
            shapes: PaymentSheetShape(borderRadius: 16),
          ),
        ),
      );
    } on StripeException catch (e) {
      throw _mapStripeException(e);
    } catch (_) {
      throw const PaymentUnknownFailure(
        code: 'payment_sheet_init_failed',
        message: 'Could not prepare secure payment form. Please try again.',
      );
    }
  }

  Future<bool> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      throw _mapStripeException(e);
    } catch (_) {
      throw const PaymentUnknownFailure(
        code: 'payment_sheet_unknown_error',
        message: 'Payment could not be completed. Please try again.',
      );
    }
  }

  Future<void> confirmPayment(String paymentIntentId) async {
    try {
      await _dio.post(
        ApiEndpoints.confirmPayment,
        data: {'paymentIntentId': paymentIntentId},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (_) {
      throw const PaymentUnknownFailure(
        code: 'payment_confirm_unexpected_error',
        message: 'Payment finished but confirmation failed. Please contact support.',
      );
    }
  }

  Future<bool> processPayment({
    required double amount,
    required String currency,
    required String customerId,
    required String merchantName,
    String? description,
  }) async {
    try {
      final paymentIntent = await createPaymentIntent(
        amount: amount,
        currency: currency,
        customerId: customerId,
        description: description,
      );

      final clientSecret = paymentIntent['client_secret'] as String?;
      final paymentIntentId = paymentIntent['id'] as String?;
      final requiresServerConfirmation =
          paymentIntent['requires_server_confirmation'] == true;

      if (clientSecret == null || clientSecret.isEmpty) {
        throw const PaymentUnknownFailure(
          code: 'payment_missing_client_secret',
          message: 'Payment setup was incomplete. Please try again.',
        );
      }

      await initPaymentSheet(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: merchantName,
      );

      await presentPaymentSheet();

      if (requiresServerConfirmation &&
          paymentIntentId != null &&
          paymentIntentId.isNotEmpty) {
        await confirmPayment(paymentIntentId);
      }

      return true;
    } on PaymentCanceledFailure {
      return false;
    } on PaymentFailure {
      rethrow;
    } catch (_) {
      throw const PaymentUnknownFailure(
        code: 'payment_process_unknown_error',
        message: 'Unable to process payment at the moment. Please try again.',
      );
    }
  }

  PaymentFailure _mapDioException(DioException e) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 400 || statusCode == 402 || statusCode == 409) {
      return const PaymentDeclinedFailure(
        code: 'payment_declined',
        message: 'Your payment was declined. Try another card or payment method.',
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return const PaymentNetworkFailure(
        code: 'payment_server_unavailable',
        message: 'Payment service is temporarily unavailable. Please try again shortly.',
      );
    }

    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const PaymentNetworkFailure(
        code: 'payment_network_error',
        message: 'No internet connection. Please check your network and try again.',
      );
    }

    if (e.type == DioExceptionType.cancel) {
      return const PaymentCanceledFailure(
        code: 'payment_request_canceled',
        message: 'Payment request was canceled.',
      );
    }

    return const PaymentUnknownFailure(
      code: 'payment_backend_error',
      message: 'Something went wrong while contacting payment server.',
    );
  }

  PaymentFailure _mapStripeException(StripeException e) {
    if (e.error.code == FailureCode.Canceled) {
      return const PaymentCanceledFailure(
        code: 'payment_canceled',
        message: 'Payment was canceled.',
      );
    }

    if (e.error.code == FailureCode.Failed || e.error.code == FailureCode.Timeout) {
      return PaymentDeclinedFailure(
        code: 'payment_failed',
        message: e.error.localizedMessage ??
            'Your payment could not be completed. Please verify card details and try again.',
      );
    }

    return PaymentUnknownFailure(
      code: 'payment_stripe_error',
      message: e.error.localizedMessage ??
          'Payment provider returned an unexpected error. Please try again.',
    );
  }
}

sealed class PaymentFailure implements Exception {
  final String code;
  final String message;

  const PaymentFailure({required this.code, required this.message});

  @override
  String toString() => '$code: $message';
}

class PaymentNetworkFailure extends PaymentFailure {
  const PaymentNetworkFailure({required super.code, required super.message});
}

class PaymentDeclinedFailure extends PaymentFailure {
  const PaymentDeclinedFailure({required super.code, required super.message});
}

class PaymentCanceledFailure extends PaymentFailure {
  const PaymentCanceledFailure({required super.code, required super.message});
}

class PaymentUnknownFailure extends PaymentFailure {
  const PaymentUnknownFailure({required super.code, required super.message});
}

class _PaymentAuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}

class _PaymentRetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxAttempts;

  const _PaymentRetryInterceptor({required this.dio, required this.maxAttempts});

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = (err.requestOptions.extra['retry_attempt'] as int?) ?? 0;
    if (!_shouldRetry(err) || attempt >= maxAttempts) {
      handler.next(err);
      return;
    }

    final nextAttempt = attempt + 1;
    final retryDelay = Duration(milliseconds: 300 * (1 << (nextAttempt - 1)));
    await Future<void>.delayed(retryDelay);

    final retryOptions = err.requestOptions.copyWith(
      extra: {...err.requestOptions.extra, 'retry_attempt': nextAttempt},
    );

    try {
      final response = await dio.fetch<dynamic>(retryOptions);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    final statusCode = err.response?.statusCode;
    final isNetworkIssue = err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout;
    final is5xx = statusCode != null && statusCode >= 500;
    return isNetworkIssue || is5xx;
  }
}
