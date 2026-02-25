import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/booking_model.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/rounded_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/utils/helpers.dart';
import '../../app/providers.dart';
import 'booking_checkout_data.dart';

class ConfirmPayPage extends ConsumerStatefulWidget {
  const ConfirmPayPage({super.key, required this.checkoutData});

  final BookingCheckoutData checkoutData;

  @override
  ConsumerState<ConfirmPayPage> createState() => _ConfirmPayPageState();
}

class _ConfirmPayPageState extends ConsumerState<ConfirmPayPage> {
  String _paymentMethod = 'card';
  bool _isProcessing = false;
  String? _paymentError;

  double get _paymentAmount => widget.checkoutData.total;

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
      _paymentError = null;
    });

    try {
      final paymentService = ref.read(paymentServiceProvider);
      final databaseService = ref.read(databaseServiceProvider);
      final user = ref.read(currentUserProvider).valueOrNull;
      final customerId = user?.id.isNotEmpty == true ? user!.id : 'guest';

      final bookingId = await databaseService.createPendingBooking(
        BookingModel(
          id: '',
          userId: customerId,
          itemId: widget.checkoutData.itemId,
          type: widget.checkoutData.type,
          itemName: widget.checkoutData.itemName,
          itemImage: widget.checkoutData.itemImage,
          startDate: widget.checkoutData.startDate,
          endDate: widget.checkoutData.endDate,
          guestCount: widget.checkoutData.guestCount,
          subtotal: widget.checkoutData.subtotal,
          serviceFee: widget.checkoutData.serviceFee,
          taxes: widget.checkoutData.taxes,
          discount: widget.checkoutData.discount,
          total: widget.checkoutData.total,
          currency: widget.checkoutData.currency,
          createdAt: DateTime.now(),
        ),
      );

      String paymentStatus = 'failed';
      String paymentId = '';
      String? errorMessage;

      if (_paymentMethod == 'card') {
        final result = await paymentService.processPayment(
          amount: _paymentAmount,
          currency: widget.checkoutData.currency,
          customerId: customerId,
          merchantName: 'Discover Egypt',
          description: 'Travel booking payment',
        );
        paymentStatus = result.status;
        paymentId = result.paymentId;
        errorMessage = result.errorMessage;
      } else if (_paymentMethod == 'wallet') {
        final walletResult = await paymentService.processWalletPayment(
          bookingId: bookingId,
          amount: _paymentAmount,
          customerId: customerId,
        );
        paymentStatus = walletResult.status;
        paymentId = walletResult.paymentId;
      } else if (_paymentMethod == 'cash') {
        final cashResult = await paymentService.markCashOnArrival(
          bookingId: bookingId,
          amount: _paymentAmount,
        );
        paymentStatus = cashResult.status;
        paymentId = cashResult.paymentId;
      }

      final normalizedStatus = paymentStatus.toLowerCase();
      await databaseService.upsertPaymentReconciliation(
        bookingId: bookingId,
        paymentId: paymentId.isNotEmpty
            ? paymentId
            : 'payment_${DateTime.now().millisecondsSinceEpoch}',
        paymentMethod: _paymentMethod,
        paymentStatus: normalizedStatus,
        amount: _paymentAmount,
        isPaid: normalizedStatus == 'succeeded',
        userId: user?.id,
      );

      await databaseService.applyBackendPaymentStatus(
        bookingId: bookingId,
        paymentStatus: normalizedStatus,
      );

      if (!mounted) return;

      if (normalizedStatus == 'succeeded') {
        context.go('/payment-success');
        return;
      }

      if (normalizedStatus == 'canceled' || normalizedStatus == 'cancelled') {
        setState(() {
          _paymentError =
              'You canceled the payment. You can retry whenever you are ready.';
        });
        return;
      }

      if (normalizedStatus == 'declined' ||
          normalizedStatus == 'requires_payment_method' ||
          normalizedStatus == 'failed') {
        setState(() {
          _paymentError = errorMessage ??
              'Your card was declined. Please use another card or retry.';
        });
        return;
      }

      setState(() {
        _paymentError = 'Payment could not be completed ($normalizedStatus).';
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _paymentError = 'Payment failed: $e';
        });
        Helpers.showSnackBar(context, 'Payment failed: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).valueOrNull;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Payment',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 16),
            RoundedCard(
              child: Column(
                children: [
                  _PaymentMethodTile(
                    icon: Icons.credit_card_rounded,
                    title: 'Credit / Debit Card',
                    subtitle: 'Secure Stripe PaymentSheet checkout',
                    value: 'card',
                    groupValue: _paymentMethod,
                    onChanged: (value) =>
                        setState(() => _paymentMethod = value!),
                  ),
                  const Divider(height: 24),
                  _PaymentMethodTile(
                    icon: Icons.account_balance_wallet_rounded,
                    title: 'Wallet',
                    subtitle:
                        'Balance: \$${user?.walletBalance.toStringAsFixed(2) ?? '0.00'}',
                    value: 'wallet',
                    groupValue: _paymentMethod,
                    onChanged: (value) =>
                        setState(() => _paymentMethod = value!),
                  ),
                  const Divider(height: 24),
                  _PaymentMethodTile(
                    icon: Icons.money_rounded,
                    title: 'Cash',
                    subtitle: 'Pay at property',
                    value: 'cash',
                    groupValue: _paymentMethod,
                    onChanged: (value) =>
                        setState(() => _paymentMethod = value!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_paymentMethod == 'card')
              const RoundedCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.verified_user_rounded),
                  title: Text('Card details are collected in Stripe PaymentSheet'),
                  subtitle: Text(
                    'We do not collect raw card number, expiry, or CVV in-app.',
                  ),
                ),
              ),
            if (_paymentMethod == 'card') const SizedBox(height: 24),
            if (_paymentError != null) ...[
              RoundedCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment issue',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.red.shade700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(_paymentError!),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _isProcessing ? null : _processPayment,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry payment'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            RoundedCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.lock_rounded,
                        color: Colors.green[600], size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Secure Payment',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.green[600],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Your payment information is encrypted and secure',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: _paymentError == null
                  ? 'Pay \$${_paymentAmount.toStringAsFixed(2)}'
                  : 'Retry \$${_paymentAmount.toStringAsFixed(2)}',
              icon: Icons.lock_rounded,
              isLoading: _isProcessing,
              onPressed: _processPayment,
            ),
            const SizedBox(height: 16),
            Text(
              'By completing this booking, you agree to our Terms of Service and Privacy Policy.',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _PaymentMethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  State<_PaymentMethodTile> createState() => _PaymentMethodTileState();
}

class _PaymentMethodTileState extends State<_PaymentMethodTile> {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.value == widget.groupValue;

    return InkWell(
      onTap: () => widget.onChanged(widget.value),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFC89B3C).withValues(alpha: 0.15)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.icon,
                color: isSelected ? const Color(0xFFC89B3C) : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color:
                          isSelected ? const Color(0xFFC89B3C) : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
