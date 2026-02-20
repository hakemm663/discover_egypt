import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/models/user_model.dart';
import '../../core/services/payment_service.dart';

enum CheckoutStatus { idle, loading, success, error }

class CheckoutState {
  final CheckoutStatus status;
  final String? errorMessage;

  const CheckoutState({
    required this.status,
    this.errorMessage,
  });

  const CheckoutState.idle() : this(status: CheckoutStatus.idle);

  CheckoutState copyWith({
    CheckoutStatus? status,
    String? errorMessage,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class CheckoutCardDetails {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardholderName;

  const CheckoutCardDetails({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardholderName,
  });

  bool get isComplete =>
      cardNumber.isNotEmpty &&
      expiryDate.isNotEmpty &&
      cvv.isNotEmpty &&
      cardholderName.isNotEmpty;
}

final checkoutControllerProvider =
    StateNotifierProvider.autoDispose<CheckoutController, CheckoutState>((ref) {
  return CheckoutController(
    paymentService: ref.read(paymentServiceProvider),
    currentUserGetter: () => ref.read(currentUserProvider),
  );
});

class CheckoutController extends StateNotifier<CheckoutState> {
  final PaymentService _paymentService;
  final UserModel? Function() _currentUserGetter;
  final Duration _placeholderDelay;

  CheckoutController({
    required PaymentService paymentService,
    required UserModel? Function() currentUserGetter,
    Duration placeholderDelay = const Duration(seconds: 1),
  })  : _paymentService = paymentService,
        _currentUserGetter = currentUserGetter,
        _placeholderDelay = placeholderDelay,
        super(const CheckoutState.idle());

  Future<void> processPayment({
    required String paymentMethod,
    CheckoutCardDetails? cardDetails,
  }) async {
    if (state.status == CheckoutStatus.loading) {
      return;
    }

    switch (paymentMethod) {
      case 'card':
        await processCardPayment(cardDetails);
        return;
      case 'wallet':
        await _processWalletPayment();
        return;
      case 'cash':
        await _processCashPayment();
        return;
      default:
        state = const CheckoutState(
          status: CheckoutStatus.error,
          errorMessage: 'Unsupported payment method',
        );
    }
  }

  Future<void> processCardPayment(CheckoutCardDetails? cardDetails) async {
    if (cardDetails == null || !cardDetails.isComplete) {
      state = const CheckoutState(
        status: CheckoutStatus.error,
        errorMessage: 'Please fill all card details',
      );
      return;
    }

    state = const CheckoutState(status: CheckoutStatus.loading);

    try {
      final user = _currentUserGetter();
      final success = await _paymentService.processPayment(
        amount: 410.40,
        currency: 'USD',
        customerId: user?.id.isNotEmpty == true ? user!.id : 'guest',
        merchantName: 'Discover Egypt',
        description: 'Travel booking payment',
      );

      if (!success) {
        state = const CheckoutState(
          status: CheckoutStatus.error,
          errorMessage: 'Payment canceled',
        );
        return;
      }

      state = const CheckoutState(status: CheckoutStatus.success);
    } catch (e) {
      state = CheckoutState(
        status: CheckoutStatus.error,
        errorMessage: 'Payment failed: $e',
      );
    }
  }

  Future<void> _processWalletPayment() async {
    state = const CheckoutState(status: CheckoutStatus.loading);
    await Future.delayed(_placeholderDelay);
    state = const CheckoutState(status: CheckoutStatus.success);
  }

  Future<void> _processCashPayment() async {
    state = const CheckoutState(status: CheckoutStatus.loading);
    await Future.delayed(_placeholderDelay);
    state = const CheckoutState(status: CheckoutStatus.success);
  }

  void clearState() {
    state = const CheckoutState.idle();
  }
}
