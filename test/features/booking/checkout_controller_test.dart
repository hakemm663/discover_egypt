import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:discover_egypt/core/models/user_model.dart';
import 'package:discover_egypt/core/services/payment_service.dart';
import 'package:discover_egypt/features/booking/checkout_controller.dart';


class _PendingPaymentService extends PaymentService {
  final Completer<bool> _completer = Completer<bool>();

  void complete(bool value) => _completer.complete(value);

  @override
  Future<bool> processPayment({
    required double amount,
    required String currency,
    required String customerId,
    required String merchantName,
    String? description,
  }) {
    return _completer.future;
  }
}

class _FakePaymentService extends PaymentService {
  _FakePaymentService({
    this.shouldSucceed = true,
    this.shouldThrow = false,
  });

  bool shouldSucceed;
  bool shouldThrow;
  bool wasCalled = false;
  String? capturedCustomerId;

  @override
  Future<bool> processPayment({
    required double amount,
    required String currency,
    required String customerId,
    required String merchantName,
    String? description,
  }) async {
    wasCalled = true;
    capturedCustomerId = customerId;

    if (shouldThrow) {
      throw Exception('boom');
    }

    return shouldSucceed;
  }
}

void main() {
  group('CheckoutController', () {
    test('starts in idle state', () {
      final controller = CheckoutController(
        paymentService: _FakePaymentService(),
        currentUserGetter: () => null,
      );

      expect(controller.state.status, CheckoutStatus.idle);
      expect(controller.state.errorMessage, isNull);
    });

    test('emits error when card details are incomplete', () async {
      final paymentService = _FakePaymentService();
      final controller = CheckoutController(
        paymentService: paymentService,
        currentUserGetter: () => null,
      );

      await controller.processCardPayment(
        const CheckoutCardDetails(
          cardNumber: '',
          expiryDate: '12/30',
          cvv: '123',
          cardholderName: 'User',
        ),
      );

      expect(controller.state.status, CheckoutStatus.error);
      expect(controller.state.errorMessage, 'Please fill all card details');
      expect(paymentService.wasCalled, isFalse);
    });

    test('emits loading then success for successful card payment', () async {
      final paymentService = _FakePaymentService(shouldSucceed: true);
      final controller = CheckoutController(
        paymentService: paymentService,
        currentUserGetter: () => UserModel(
          id: 'user_1',
          email: 'user@test.com',
          fullName: 'User One',
          createdAt: DateTime(2024),
        ),
      );

      final statuses = <CheckoutStatus>[];
      controller.addListener((state) => statuses.add(state.status));

      await controller.processPayment(
        paymentMethod: 'card',
        cardDetails: const CheckoutCardDetails(
          cardNumber: '4111111111111111',
          expiryDate: '12/30',
          cvv: '123',
          cardholderName: 'User One',
        ),
      );

      expect(statuses, [CheckoutStatus.loading, CheckoutStatus.success]);
      expect(controller.state.status, CheckoutStatus.success);
      expect(paymentService.capturedCustomerId, 'user_1');
    });

    test('uses guest customer id when user id is empty', () async {
      final paymentService = _FakePaymentService(shouldSucceed: true);
      final controller = CheckoutController(
        paymentService: paymentService,
        currentUserGetter: () => UserModel(
          id: '',
          email: 'user@test.com',
          fullName: 'User One',
          createdAt: DateTime(2024),
        ),
      );

      await controller.processCardPayment(
        const CheckoutCardDetails(
          cardNumber: '4111111111111111',
          expiryDate: '12/30',
          cvv: '123',
          cardholderName: 'User One',
        ),
      );

      expect(paymentService.capturedCustomerId, 'guest');
    });

    test('emits error when payment is canceled', () async {
      final paymentService = _FakePaymentService(shouldSucceed: false);
      final controller = CheckoutController(
        paymentService: paymentService,
        currentUserGetter: () => null,
      );

      await controller.processCardPayment(
        const CheckoutCardDetails(
          cardNumber: '4111111111111111',
          expiryDate: '12/30',
          cvv: '123',
          cardholderName: 'User One',
        ),
      );

      expect(controller.state.status, CheckoutStatus.error);
      expect(controller.state.errorMessage, 'Payment canceled');
    });

    test('emits error when payment service throws', () async {
      final paymentService = _FakePaymentService(shouldThrow: true);
      final controller = CheckoutController(
        paymentService: paymentService,
        currentUserGetter: () => null,
      );

      await controller.processCardPayment(
        const CheckoutCardDetails(
          cardNumber: '4111111111111111',
          expiryDate: '12/30',
          cvv: '123',
          cardholderName: 'User One',
        ),
      );

      expect(controller.state.status, CheckoutStatus.error);
      expect(controller.state.errorMessage, contains('Payment failed:'));
    });


    test('does not update state after disposal during card payment', () async {
      final paymentService = _PendingPaymentService();
      final controller = CheckoutController(
        paymentService: paymentService,
        currentUserGetter: () => null,
      );

      final paymentFuture = controller.processCardPayment(
        const CheckoutCardDetails(
          cardNumber: '4111111111111111',
          expiryDate: '12/30',
          cvv: '123',
          cardholderName: 'User One',
        ),
      );

      controller.dispose();
      paymentService.complete(true);

      await paymentFuture;

      expect(controller.mounted, isFalse);
    });

    test('processes wallet payment with loading and success', () async {
      final paymentService = _FakePaymentService();
      final controller = CheckoutController(
        paymentService: paymentService,
        currentUserGetter: () => null,
        placeholderDelay: Duration.zero,
      );

      final statuses = <CheckoutStatus>[];
      controller.addListener((state) => statuses.add(state.status));

      await controller.processPayment(paymentMethod: 'wallet');

      expect(statuses, [CheckoutStatus.loading, CheckoutStatus.success]);
      expect(paymentService.wasCalled, isFalse);
    });
  });
}
