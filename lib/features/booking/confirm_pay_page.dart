import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/utils/helpers.dart';
import '../../core/widgets/app_bar_widget.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/rounded_card.dart';

class ConfirmPayPage extends ConsumerStatefulWidget {
  const ConfirmPayPage({super.key});

  @override
  ConsumerState<ConfirmPayPage> createState() => _ConfirmPayPageState();
}

class _ConfirmPayPageState extends ConsumerState<ConfirmPayPage> {
  static const double _bookingAmount = 410.40;

  String _paymentMethod = 'card';
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      if (_paymentMethod == 'card') {
        final paymentService = ref.read(paymentServiceProvider);
        final user = ref.read(currentUserProvider);

        final success = await paymentService.processPayment(
          amount: _bookingAmount,
          currency: 'USD',
          customerId: user?.id.isNotEmpty == true ? user!.id : 'guest',
          merchantName: 'Discover Egypt',
          description: 'Travel booking payment',
        );

        if (!success) {
          if (mounted) {
            Helpers.showSnackBar(context, 'Payment canceled', isError: true);
          }
          return;
        }
      } else if (_paymentMethod == 'wallet') {
        final user = ref.read(currentUserProvider);
        final balance = user?.walletBalance ?? 0;

        if (balance < _bookingAmount) {
          if (mounted) {
            Helpers.showSnackBar(
              context,
              'Insufficient wallet balance',
              isError: true,
            );
          }
          return;
        }

        await Future.delayed(const Duration(milliseconds: 700));
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      if (mounted) {
        context.go('/payment-success');
      }
    } catch (e) {
      if (mounted) {
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
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: const CustomAppBar(
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
                    subtitle: 'Processed securely with Stripe PaymentSheet',
                    value: 'card',
                    groupValue: _paymentMethod,
                    onChanged: (value) => setState(() => _paymentMethod = value!),
                  ),
                  const Divider(height: 24),
                  _PaymentMethodTile(
                    icon: Icons.account_balance_wallet_rounded,
                    title: 'Wallet',
                    subtitle:
                        'Balance: \$${user?.walletBalance.toStringAsFixed(2) ?? '0.00'}',
                    value: 'wallet',
                    groupValue: _paymentMethod,
                    onChanged: (value) => setState(() => _paymentMethod = value!),
                  ),
                  const Divider(height: 24),
                  _PaymentMethodTile(
                    icon: Icons.money_rounded,
                    title: 'Cash',
                    subtitle: 'Pay at property',
                    value: 'cash',
                    groupValue: _paymentMethod,
                    onChanged: (value) => setState(() => _paymentMethod = value!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_paymentMethod == 'card')
              const RoundedCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.verified_user_rounded, color: Color(0xFFC89B3C)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Card details are collected in Stripe\'s secure payment sheet. '
                        'No card numbers are stored in the app.',
                      ),
                    ),
                  ],
                ),
              ),
            if (_paymentMethod == 'card') const SizedBox(height: 16),
            RoundedCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      color: Colors.green[600],
                      size: 24,
                    ),
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
              label: 'Pay \$${_bookingAmount.toStringAsFixed(2)}',
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
                    ? const Color(0xFFC89B3C).withOpacity(0.15)
                    : Colors.grey.withOpacity(0.1),
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
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
            Radio<String>(
              value: widget.value,
              groupValue: widget.groupValue,
              onChanged: widget.onChanged,
              activeColor: const Color(0xFFC89B3C),
            ),
          ],
        ),
      ),
    );
  }
}
