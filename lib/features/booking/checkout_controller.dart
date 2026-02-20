import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CheckoutFailureReason {
  insufficientWalletBalance,
  walletServiceFailure,
  reservationHoldFailure,
  reservationConfirmFailure,
}

class CheckoutState {
  final bool isProcessing;
  final bool isSuccess;
  final String? successReservationId;
  final String? userMessage;
  final CheckoutFailureReason? failureReason;

  const CheckoutState({
    this.isProcessing = false,
    this.isSuccess = false,
    this.successReservationId,
    this.userMessage,
    this.failureReason,
  });

  CheckoutState copyWith({
    bool? isProcessing,
    bool? isSuccess,
    String? successReservationId,
    String? userMessage,
    CheckoutFailureReason? failureReason,
    bool clearFailureReason = false,
    bool clearMessage = false,
  }) {
    return CheckoutState(
      isProcessing: isProcessing ?? this.isProcessing,
      isSuccess: isSuccess ?? this.isSuccess,
      successReservationId: successReservationId ?? this.successReservationId,
      userMessage: clearMessage ? null : userMessage ?? this.userMessage,
      failureReason: clearFailureReason
          ? null
          : failureReason ?? this.failureReason,
    );
  }
}

enum WalletDebitError { insufficientFunds, backendFailure, unknown }

class WalletDebitResult {
  final bool isSuccess;
  final WalletDebitError? error;

  const WalletDebitResult._({required this.isSuccess, this.error});

  const WalletDebitResult.success() : this._(isSuccess: true);

  const WalletDebitResult.failure(WalletDebitError error)
      : this._(isSuccess: false, error: error);
}

class ReservationHoldResult {
  final String? holdId;
  final ReservationError? error;

  const ReservationHoldResult._({this.holdId, this.error});

  bool get isSuccess => holdId != null;

  const ReservationHoldResult.success(String holdId) : this._(holdId: holdId);

  const ReservationHoldResult.failure(ReservationError error)
      : this._(error: error);
}

class ReservationConfirmResult {
  final String? reservationId;
  final ReservationError? error;

  const ReservationConfirmResult._({this.reservationId, this.error});

  bool get isSuccess => reservationId != null;

  const ReservationConfirmResult.success(String reservationId)
      : this._(reservationId: reservationId);

  const ReservationConfirmResult.failure(ReservationError error)
      : this._(error: error);
}

enum ReservationError { backendFailure, holdExpired, unknown }

abstract class WalletPaymentService {
  Future<WalletDebitResult> debit({
    required String userId,
    required double amount,
  });
}

abstract class ReservationService {
  Future<ReservationHoldResult> hold({
    required String bookingId,
    required double amount,
  });

  Future<ReservationConfirmResult> confirm({
    required String holdId,
    required String paymentMethod,
  });
}

class CheckoutController extends StateNotifier<CheckoutState> {
  CheckoutController({
    required WalletPaymentService walletPaymentService,
    required ReservationService reservationService,
  })  : _walletPaymentService = walletPaymentService,
        _reservationService = reservationService,
        super(const CheckoutState());

  final WalletPaymentService _walletPaymentService;
  final ReservationService _reservationService;

  Future<void> processWalletPayment({
    required String userId,
    required String bookingId,
    required double amount,
  }) {
    return _processWalletPayment(
      userId: userId,
      bookingId: bookingId,
      amount: amount,
    );
  }

  Future<void> processCashPayment({
    required String bookingId,
    required double amount,
  }) {
    return _processCashPayment(bookingId: bookingId, amount: amount);
  }

  Future<void> _processWalletPayment({
    required String userId,
    required String bookingId,
    required double amount,
  }) async {
    state = const CheckoutState(isProcessing: true);

    final debitResult = await _walletPaymentService.debit(
      userId: userId,
      amount: amount,
    );

    if (!debitResult.isSuccess) {
      switch (debitResult.error) {
        case WalletDebitError.insufficientFunds:
          state = const CheckoutState(
            userMessage:
                'Your wallet balance is too low for this booking. Please top up and try again.',
            failureReason: CheckoutFailureReason.insufficientWalletBalance,
          );
          return;
        case WalletDebitError.backendFailure:
        case WalletDebitError.unknown:
        case null:
          state = const CheckoutState(
            userMessage: 'We could not process your wallet payment right now.',
            failureReason: CheckoutFailureReason.walletServiceFailure,
          );
          return;
      }
    }

    final holdResult = await _reservationService.hold(
      bookingId: bookingId,
      amount: amount,
    );

    if (!holdResult.isSuccess) {
      state = const CheckoutState(
        userMessage: 'We could not secure your reservation. Please try again.',
        failureReason: CheckoutFailureReason.reservationHoldFailure,
      );
      return;
    }

    final confirmResult = await _reservationService.confirm(
      holdId: holdResult.holdId!,
      paymentMethod: 'wallet',
    );

    if (!confirmResult.isSuccess) {
      state = const CheckoutState(
        userMessage: 'Payment was captured, but booking confirmation failed.',
        failureReason: CheckoutFailureReason.reservationConfirmFailure,
      );
      return;
    }

    state = CheckoutState(
      isSuccess: true,
      successReservationId: confirmResult.reservationId,
    );
  }

  Future<void> _processCashPayment({
    required String bookingId,
    required double amount,
  }) async {
    state = const CheckoutState(isProcessing: true);

    final holdResult = await _reservationService.hold(
      bookingId: bookingId,
      amount: amount,
    );

    if (!holdResult.isSuccess) {
      state = const CheckoutState(
        userMessage: 'We could not place your cash reservation right now.',
        failureReason: CheckoutFailureReason.reservationHoldFailure,
      );
      return;
    }

    final confirmResult = await _reservationService.confirm(
      holdId: holdResult.holdId!,
      paymentMethod: 'cash',
    );

    if (!confirmResult.isSuccess) {
      state = const CheckoutState(
        userMessage: 'Reservation hold succeeded, but final confirmation failed.',
        failureReason: CheckoutFailureReason.reservationConfirmFailure,
      );
      return;
    }

    state = CheckoutState(
      isSuccess: true,
      successReservationId: confirmResult.reservationId,
    );
  }
}
