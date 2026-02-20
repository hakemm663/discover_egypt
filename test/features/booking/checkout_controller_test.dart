import 'package:discover_egypt/features/booking/checkout_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeWalletPaymentService implements WalletPaymentService {
  _FakeWalletPaymentService(this.result);

  WalletDebitResult result;

  @override
  Future<WalletDebitResult> debit({
    required String userId,
    required double amount,
  }) async {
    return result;
  }
}

class _FakeReservationService implements ReservationService {
  _FakeReservationService({
    required this.holdResult,
    required this.confirmResult,
  });

  ReservationHoldResult holdResult;
  ReservationConfirmResult confirmResult;

  @override
  Future<ReservationHoldResult> hold({
    required String bookingId,
    required double amount,
  }) async {
    return holdResult;
  }

  @override
  Future<ReservationConfirmResult> confirm({
    required String holdId,
    required String paymentMethod,
  }) async {
    return confirmResult;
  }
}

void main() {
  group('CheckoutController.processWalletPayment', () {
    test('maps insufficient wallet balance to safe user message', () async {
      final controller = CheckoutController(
        walletPaymentService: _FakeWalletPaymentService(
          const WalletDebitResult.failure(WalletDebitError.insufficientFunds),
        ),
        reservationService: _FakeReservationService(
          holdResult: const ReservationHoldResult.success('hold_1'),
          confirmResult: const ReservationConfirmResult.success('res_1'),
        ),
      );

      await controller.processWalletPayment(
        userId: 'u1',
        bookingId: 'b1',
        amount: 100,
      );

      expect(controller.state.isSuccess, isFalse);
      expect(
        controller.state.failureReason,
        CheckoutFailureReason.insufficientWalletBalance,
      );
      expect(controller.state.userMessage, contains('wallet balance is too low'));
    });

    test('maps reservation backend hold failure', () async {
      final controller = CheckoutController(
        walletPaymentService:
            _FakeWalletPaymentService(const WalletDebitResult.success()),
        reservationService: _FakeReservationService(
          holdResult:
              const ReservationHoldResult.failure(ReservationError.backendFailure),
          confirmResult: const ReservationConfirmResult.success('res_1'),
        ),
      );

      await controller.processWalletPayment(
        userId: 'u1',
        bookingId: 'b1',
        amount: 100,
      );

      expect(controller.state.isSuccess, isFalse);
      expect(
        controller.state.failureReason,
        CheckoutFailureReason.reservationHoldFailure,
      );
      expect(controller.state.userMessage, contains('secure your reservation'));
    });

    test('completes wallet checkout successfully', () async {
      final controller = CheckoutController(
        walletPaymentService:
            _FakeWalletPaymentService(const WalletDebitResult.success()),
        reservationService: _FakeReservationService(
          holdResult: const ReservationHoldResult.success('hold_1'),
          confirmResult: const ReservationConfirmResult.success('res_wallet_ok'),
        ),
      );

      await controller.processWalletPayment(
        userId: 'u1',
        bookingId: 'b1',
        amount: 100,
      );

      expect(controller.state.isSuccess, isTrue);
      expect(controller.state.successReservationId, 'res_wallet_ok');
      expect(controller.state.failureReason, isNull);
    });
  });

  group('CheckoutController.processCashPayment', () {
    test('maps backend hold failure', () async {
      final controller = CheckoutController(
        walletPaymentService:
            _FakeWalletPaymentService(const WalletDebitResult.success()),
        reservationService: _FakeReservationService(
          holdResult:
              const ReservationHoldResult.failure(ReservationError.backendFailure),
          confirmResult: const ReservationConfirmResult.success('res_1'),
        ),
      );

      await controller.processCashPayment(bookingId: 'b1', amount: 100);

      expect(controller.state.isSuccess, isFalse);
      expect(
        controller.state.failureReason,
        CheckoutFailureReason.reservationHoldFailure,
      );
      expect(controller.state.userMessage, contains('cash reservation'));
    });

    test('completes cash checkout successfully', () async {
      final controller = CheckoutController(
        walletPaymentService:
            _FakeWalletPaymentService(const WalletDebitResult.success()),
        reservationService: _FakeReservationService(
          holdResult: const ReservationHoldResult.success('hold_2'),
          confirmResult: const ReservationConfirmResult.success('res_cash_ok'),
        ),
      );

      await controller.processCashPayment(bookingId: 'b1', amount: 100);

      expect(controller.state.isSuccess, isTrue);
      expect(controller.state.successReservationId, 'res_cash_ok');
      expect(controller.state.failureReason, isNull);
    });
  });
}
