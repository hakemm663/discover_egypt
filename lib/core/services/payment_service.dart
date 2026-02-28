import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../config/app_config.dart';
import '../constants/api_endpoints.dart';

class PaymentOperationResult {
  final String bookingId;
  final String paymentId;
  final String status;

  const PaymentOperationResult({
    required this.bookingId,
    required this.paymentId,
    required this.status,
  });
}

class PaymentFlowResult {
  const PaymentFlowResult({
    required this.paymentId,
    required this.status,
    this.errorMessage,
  });

  final String paymentId;
  final String status;
  final String? errorMessage;

  bool get isSuccess => status == 'succeeded';
}

class PaymentService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Contract: POST /payments/create-intent
  /// Request: {amount:int minorUnits, currency:string, customerId:string, description?:string}
  /// Response: {id:string, client_secret:string, status:string, requires_server_confirmation?:bool}
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
    } catch (e) {
      throw Exception('Failed to create payment intent from backend: $e');
    }
  }

  /// Contract: POST /payments/wallet/charge (top-up intent mode)
  /// Request: {amount:int minorUnits, currency:string, customerId:string, purpose:"wallet_topup"}
  /// Response: {id:string, client_secret:string, status:string, requires_server_confirmation?:bool}
  Future<Map<String, dynamic>> createWalletTopUpIntent({
    required double amount,
    required String currency,
    required String customerId,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.walletCharge,
        data: {
          'amount': (amount * 100).toInt(),
          'currency': currency.toLowerCase(),
          'customerId': customerId,
          'purpose': 'wallet_topup',
          'paymentMethod': 'card',
        },
      );

      return Map<String, dynamic>.from(response.data as Map);
    } catch (e) {
      throw Exception('Failed to create wallet top-up intent from backend: $e');
    }
  }

  Future<void> initPaymentSheet({
    required String paymentIntentClientSecret,
    required String merchantDisplayName,
    String? customerId,
    String? customerEphemeralKeySecret,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: merchantDisplayName,
        customerId: customerId,
        customerEphemeralKeySecret: customerEphemeralKeySecret,
        style: ThemeMode.system,
        appearance: const PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(
            primary: Color(0xFFC89B3C),
          ),
          shapes: PaymentSheetShape(
            borderRadius: 16,
          ),
        ),
      ),
    );
  }

  Future<PaymentFlowResult> presentPaymentSheet({required String paymentId}) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return PaymentFlowResult(paymentId: paymentId, status: 'succeeded');
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return PaymentFlowResult(
          paymentId: paymentId,
          status: 'canceled',
          errorMessage: 'Payment sheet was canceled.',
        );
      }
      return PaymentFlowResult(
        paymentId: paymentId,
        status: 'declined',
        errorMessage: e.error.message ?? 'Card was declined.',
      );
    }
  }

  /// Contract: POST /payments/confirm
  /// Request: {paymentIntentId:string}
  /// Response: {id:string, status:string}
  Future<Map<String, dynamic>> confirmPayment(String paymentIntentId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.confirmPayment,
        data: {'paymentIntentId': paymentIntentId},
      );
      return Map<String, dynamic>.from(response.data as Map);
    } catch (e) {
      throw Exception('Failed to confirm payment from backend: $e');
    }
  }

  Future<PaymentOperationResult> processWalletPayment({
    required String bookingId,
    required double amount,
    required String customerId,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.walletCharge,
        data: {
          'bookingId': bookingId,
          'amount': (amount * 100).toInt(),
          'currency': 'usd',
          'customerId': customerId,
          'paymentMethod': 'wallet',
        },
      );

      final data = Map<String, dynamic>.from(response.data as Map);
      return PaymentOperationResult(
        bookingId: (data['bookingId'] ?? bookingId).toString(),
        paymentId: (data['paymentId'] ?? data['id'] ?? '').toString(),
        status: (data['status'] ?? '').toString(),
      );
    } catch (e) {
      throw Exception('Failed to process wallet payment from backend: $e');
    }
  }

  /// Contract: POST /payments/cash-on-arrival
  /// Request: {bookingId:string, amount:int minorUnits, currency:string, paymentMethod:"cash"}
  /// Response: {bookingId:string, paymentId:string, status:"pending_cash_collection"|"failed"}
  Future<PaymentOperationResult> markCashOnArrival({
    required String bookingId,
    required double amount,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.cashOnArrivalIntent,
        data: {
          'bookingId': bookingId,
          'amount': (amount * 100).toInt(),
          'currency': 'usd',
          'status': 'pending_cash_collection',
          'paymentMethod': 'cash',
        },
      );

      final data = Map<String, dynamic>.from(response.data as Map);
      return PaymentOperationResult(
        bookingId: (data['bookingId'] ?? bookingId).toString(),
        paymentId: (data['paymentId'] ?? data['id'] ?? '').toString(),
        status: (data['status'] ?? '').toString(),
      );
    } catch (e) {
      throw Exception('Failed to create cash-on-arrival intent from backend: $e');
    }
  }

  Future<PaymentFlowResult> processPayment({
    required double amount,
    required String currency,
    required String customerId,
    required String merchantName,
    String? description,
  }) async {
    final paymentIntent = await createPaymentIntent(
      amount: amount,
      currency: currency,
      customerId: customerId,
      description: description,
    );

    return _completeIntentFlow(
      paymentIntent: paymentIntent,
      merchantName: merchantName,
    );
  }

  Future<PaymentFlowResult> processWalletTopUp({
    required double amount,
    required String currency,
    required String customerId,
    required String merchantName,
  }) async {
    final paymentIntent = await createWalletTopUpIntent(
      amount: amount,
      currency: currency,
      customerId: customerId,
    );

    return _completeIntentFlow(
      paymentIntent: paymentIntent,
      merchantName: merchantName,
    );
  }

  Future<PaymentFlowResult> _completeIntentFlow({
    required Map<String, dynamic> paymentIntent,
    required String merchantName,
  }) async {
    final clientSecret = paymentIntent['client_secret'] as String?;
    final paymentIntentId = paymentIntent['id']?.toString() ?? '';
    final requiresServerConfirmation =
        paymentIntent['requires_server_confirmation'] == true;

    if (clientSecret == null || clientSecret.isEmpty) {
      throw Exception('Backend did not return payment intent client secret.');
    }

    await initPaymentSheet(
      paymentIntentClientSecret: clientSecret,
      merchantDisplayName: merchantName,
    );

    final sheetResult = await presentPaymentSheet(paymentId: paymentIntentId);
    if (!sheetResult.isSuccess) {
      return sheetResult;
    }

    Map<String, dynamic>? confirmation;
    if (paymentIntentId.isNotEmpty && requiresServerConfirmation) {
      confirmation = await confirmPayment(paymentIntentId);
    }

    final resolvedStatus =
        (confirmation?['status'] ?? paymentIntent['status'] ?? 'succeeded')
            .toString()
            .toLowerCase();

    return PaymentFlowResult(
      paymentId: paymentIntentId,
      status: resolvedStatus,
    );
  }
}
