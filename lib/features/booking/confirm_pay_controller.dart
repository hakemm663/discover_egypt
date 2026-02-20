import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../app/providers.dart';

enum ConfirmPayStatus { idle, loading, success, error }

class ConfirmPayState {
  final ConfirmPayStatus status;
  final String? errorMessage;

  const ConfirmPayState({
    this.status = ConfirmPayStatus.idle,
    this.errorMessage,
  });

  bool get isLoading => status == ConfirmPayStatus.loading;

  ConfirmPayState copyWith({
    ConfirmPayStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ConfirmPayState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final confirmPayControllerProvider =
    StateNotifierProvider.autoDispose<ConfirmPayController, ConfirmPayState>(
  (ref) => ConfirmPayController(ref),
);

class ConfirmPayController extends StateNotifier<ConfirmPayState> {
  final Ref _ref;

  ConfirmPayController(this._ref) : super(const ConfirmPayState());

  Future<void> processPayment(String paymentMethod) async {
    state = state.copyWith(status: ConfirmPayStatus.loading, clearError: true);

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
            status: ConfirmPayStatus.error,
            errorMessage: 'Payment canceled',
          );
          return;
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
      }

      state = state.copyWith(status: ConfirmPayStatus.success, clearError: true);
    } catch (e) {
      state = state.copyWith(
        status: ConfirmPayStatus.error,
        errorMessage: 'Payment failed: $e',
      );
    }
  }

  void clearStatus() {
    state = const ConfirmPayState();
  }

  @visibleForTesting
  void setStateForTest(ConfirmPayState value) {
    state = value;
  }
}
