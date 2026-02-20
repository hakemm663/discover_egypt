import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_bar_widget.dart';
import '../../core/widgets/rounded_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/utils/helpers.dart';
import '../../core/services/payment_service.dart';
import '../../app/providers.dart';

class ConfirmPayPage extends ConsumerStatefulWidget {
  const ConfirmPayPage({super.key});

  @override
  ConsumerState<ConfirmPayPage> createState() => _ConfirmPayPageState();
}

class _ConfirmPayPageState extends ConsumerState<ConfirmPayPage> {
  String _paymentMethod = 'card';
  bool _saveCard = false;
  bool _isProcessing = false;

  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (_paymentMethod == 'card') {
      // Keep basic validation for current card form inputs.
      if (_cardNumberController.text.isEmpty ||
          _expiryController.text.isEmpty ||
          _cvvController.text.isEmpty ||
          _nameController.text.isEmpty) {
        Helpers.showSnackBar(
          context,
          'Please fill all card details',
          isError: true,
        );
        return;
      }
    }

    setState(() => _isProcessing = true);

    try {
      if (_paymentMethod == 'card') {
        final paymentService = ref.read(paymentServiceProvider);
        final user = ref.read(currentUserProvider);

        final success = await paymentService.processPayment(
          amount: 410.40,
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
      } else {
        // Wallet and cash flows remain local placeholders until backend wiring.
        await Future.delayed(const Duration(seconds: 1));
      }

      if (mounted) {
        context.go('/payment-success');
      }
    } on PaymentFailure catch (failure) {
      if (mounted) {
        Helpers.showSnackBar(context, failure.message, isError: true);
      }
    } catch (_) {
      if (mounted) {
        Helpers.showSnackBar(
          context,
          'Payment failed. Please try again.',
          isError: true,
        );
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
      appBar: CustomAppBar(
        title: 'Payment',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Methods
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
                    subtitle: 'Visa, Mastercard, Amex',
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

            // Card Details (if card payment selected)
            if (_paymentMethod == 'card') ...[
              Text(
                'Card Details',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 16),
              RoundedCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card Number',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                      decoration: const InputDecoration(
                        hintText: '1234 5678 9012 3456',
                        counterText: '',
                        prefixIcon: Icon(Icons.credit_card_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expiry Date',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _expiryController,
                                keyboardType: TextInputType.datetime,
                                decoration: const InputDecoration(
                                  hintText: 'MM/YY',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CVV',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _cvvController,
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: '123',
                                  counterText: '',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cardholder Name',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: 'John Doe',
                      ),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      value: _saveCard,
                      onChanged: (value) =>
                          setState(() => _saveCard = value ?? false),
                      title: const Text('Save card for future payments'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: const Color(0xFFC89B3C),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Security Notice
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

            // Pay Button
            PrimaryButton(
              label: 'Pay \$410.40',
              icon: Icons.lock_rounded,
              isLoading: _isProcessing,
              onPressed: _processPayment,
            ),

            const SizedBox(height: 16),

            // Terms
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
