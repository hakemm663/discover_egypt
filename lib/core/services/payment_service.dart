import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

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
  });

  final String paymentId;
  final String status;
}

class PaymentService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Create payment intent through secure backend endpoint.
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
          'amount': (amount * 100).toInt(), // Convert to minor currency unit
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

  // Initialize payment sheet
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

  // Present payment sheet
  Future<bool> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return false;
      }
      throw Exception('Payment failed: ${e.error.message}');
    }
  }

  // Confirm payment via backend (if server-side confirmation is required).
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

  // Process full payment flow
  Future<PaymentFlowResult> processPayment({
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

      final success = await presentPaymentSheet();
      if (!success) {
        return PaymentFlowResult(
          paymentId: paymentIntentId,
          status: 'failed',
        );
      }

      Map<String, dynamic>? confirmation;
      if (paymentIntentId.isNotEmpty) {
        confirmation = await confirmPayment(paymentIntentId);
      }

      final resolvedStatus = (confirmation?['status'] ?? paymentIntent['status'] ?? '')
          .toString()
          .toLowerCase();

      if (resolvedStatus.isNotEmpty) {
        return PaymentFlowResult(
          paymentId: paymentIntentId,
          status: resolvedStatus,
        );
      }

      return PaymentFlowResult(
        paymentId: paymentIntentId,
        status: requiresServerConfirmation ? 'requires_action' : 'succeeded',
      );
    } catch (e) {
      rethrow;
    }
  }
}
