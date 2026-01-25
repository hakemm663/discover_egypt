import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class PaymentService {
  final Dio _dio = Dio();

  // Create payment intent on your backend
  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    required String customerId,
    String? description,
  }) async {
    try {
      // In production, call your backend API
      // For demo, we'll create it directly (NOT recommended for production)
      final response = await _dio.post(
        'https://api.stripe.com/v1/payment_intents',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AppConstants.stripeSecretKey}',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'amount': (amount * 100).toInt(), // Convert to cents
          'currency': currency.toLowerCase(),
          'description': description ?? 'Discover Egypt Booking',
          'metadata[customer_id]': customerId,
        },
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
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

  // Confirm payment
  Future<PaymentIntent> confirmPayment(String clientSecret) async {
    return await Stripe.instance.confirmPayment(
      paymentIntentClientSecret: clientSecret,
    );
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
      // 1. Create payment intent
      final paymentIntent = await createPaymentIntent(
        amount: amount,
        currency: currency,
        customerId: customerId,
        description: description,
      );

      // 2. Initialize payment sheet
      await initPaymentSheet(
        paymentIntentClientSecret: paymentIntent['client_secret'],
        merchantDisplayName: merchantName,
      );

      // 3. Present payment sheet
      final success = await presentPaymentSheet();

      return success;
    } catch (e) {
      rethrow;
    }
  }
}