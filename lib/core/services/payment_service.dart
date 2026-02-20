import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../constants/api_endpoints.dart';

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
  Future<void> confirmPayment(String paymentIntentId) async {
    try {
      await _dio.post(
        ApiEndpoints.confirmPayment,
        data: {'paymentIntentId': paymentIntentId},
      );
    } catch (e) {
      throw Exception('Failed to confirm payment from backend: $e');
    }
  }

  // Process full payment flow
  Future<bool> processPayment({
    required double amount,
    required String currency,
    required String customerId,
    required String merchantName,
    String? description,
  }) async {
    try {
      // 1. Create payment intent from backend.
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
        throw Exception('Backend did not return payment intent client secret.');
      }

      // 2. Initialize payment sheet.
      await initPaymentSheet(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: merchantName,
      );

      // 3. Present payment sheet.
      final success = await presentPaymentSheet();

      // 4. Optional server-side confirmation/audit.
      if (success &&
          requiresServerConfirmation &&
          paymentIntentId != null &&
          paymentIntentId.isNotEmpty) {
        await confirmPayment(paymentIntentId);
      }

      return success;
    } catch (e) {
      rethrow;
    }
  }
}
