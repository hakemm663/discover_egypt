import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../app/providers.dart';

enum CheckoutPaymentStatus { idle, loading, success, error }

class CheckoutPaymentState {
  final CheckoutPaymentStatus status;
  final String? errorMessage;

  const CheckoutPaymentState({
    this.status = CheckoutPaymentStatus.idle,
    this.errorMessage,
  });

  bool get isLoading => status == CheckoutPaymentStatus.loading;

  CheckoutPaymentState copyWith({
    CheckoutPaymentStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CheckoutPaymentState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final checkoutPaymentControllerProvider =
    StateNotifierProvider.autoDispose<CheckoutPaymentController, CheckoutPaymentState>(
  (ref) => CheckoutPaymentController(ref),
);

class CheckoutPaymentController extends StateNotifier<CheckoutPaymentState> {
  final Ref _ref;

  CheckoutPaymentController(this._ref) : super(const CheckoutPaymentState());

  Future<void> processPayment(String paymentMethod) async {
    state = state.copyWith(status: CheckoutPaymentStatus.loading, clearError: true);

    try {
      if (paymentMethod == 'card') {
        final paymentService = _ref.read(paymentServiceProvider);
        final user = _ref.read(currentUserProvider);

        final success = await paymentService.processPayment(
          amount: 410.40,
          currency: 'USD',
          customerId: user?.id.isNotEmpty == true ? user!.id : 'guest',
          merchantName: 'Discover Egypt',
          description: 'Travel booking payment',
        );

        if (!success) {
          state = state.copyWith(
            status: CheckoutPaymentStatus.error,
            errorMessage: 'Payment canceled',
          );
          return;
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
      }

      state = state.copyWith(status: CheckoutPaymentStatus.success, clearError: true);
    } catch (e) {
      state = state.copyWith(
        status: CheckoutPaymentStatus.error,
        errorMessage: 'Payment failed: $e',
      );
    }
  }

  void clearStatus() {
    state = const CheckoutPaymentState();
  }

  @visibleForTesting
  void setStateForTest(CheckoutPaymentState value) {
    state = value;
  }
}
