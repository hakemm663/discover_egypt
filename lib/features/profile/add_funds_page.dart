import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/utils/helpers.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/rounded_card.dart';

class AddFundsPage extends ConsumerStatefulWidget {
  const AddFundsPage({super.key});

  @override
  ConsumerState<AddFundsPage> createState() => _AddFundsPageState();
}

class _AddFundsPageState extends ConsumerState<AddFundsPage> {
  static const List<double> _quickAmounts = [25, 50, 100, 200];

  final TextEditingController _amountController = TextEditingController(text: '50');
  bool _isProcessing = false;
  String? _error;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double? get _parsedAmount => double.tryParse(_amountController.text.trim());

  Future<void> _addFunds() async {
    final amount = _parsedAmount;
    if (amount == null || amount <= 0) {
      setState(() {
        _error = 'Enter a valid top-up amount.';
      });
      return;
    }

    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null || user.id.isEmpty) {
      setState(() {
        _error = 'You must be signed in to top up your wallet.';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      final paymentService = ref.read(paymentServiceProvider);
      final databaseService = ref.read(databaseServiceProvider);

      final result = await paymentService.processWalletTopUp(
        amount: amount,
        currency: 'usd',
        customerId: user.id,
        merchantName: 'Discover Egypt',
      );

      final normalized = result.status.toLowerCase();
      await databaseService.reconcileWalletTopUp(
        userId: user.id,
        amount: amount,
        paymentId: result.paymentId.isNotEmpty
            ? result.paymentId
            : 'wallet_topup_${DateTime.now().millisecondsSinceEpoch}',
        paymentStatus: normalized,
      );

      if (!mounted) return;

      if (normalized == 'succeeded') {
        Helpers.showSnackBar(context, 'Wallet topped up successfully.');
        Navigator.of(context).pop();
        return;
      }

      if (normalized == 'canceled' || normalized == 'cancelled') {
        setState(() {
          _error = 'Top-up canceled. You can retry anytime.';
        });
        return;
      }

      if (normalized == 'declined' ||
          normalized == 'requires_payment_method' ||
          normalized == 'failed') {
        setState(() {
          _error = result.errorMessage ??
              'Card was declined. Try another card and retry.';
        });
        return;
      }

      setState(() {
        _error = 'Top-up failed ($normalized). Please retry.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Unable to process top-up: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).valueOrNull;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Add Funds',
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          RoundedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Wallet Balance',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${(user?.walletBalance ?? 0).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RoundedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Top-up amount',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _quickAmounts
                      .map(
                        (amount) => ChoiceChip(
                          label: Text('\$${amount.toStringAsFixed(0)}'),
                          selected: _amountController.text == amount.toStringAsFixed(0),
                          onSelected: (_) {
                            setState(() {
                              _amountController.text = amount.toStringAsFixed(0);
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    prefixText: '\$',
                    labelText: 'Amount',
                    hintText: 'Enter amount',
                  ),
                ),
                const SizedBox(height: 12),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.credit_card_rounded),
                  title: Text('PaymentSheet checkout'),
                  subtitle: Text(
                    'Card details are securely collected by Stripe.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_error != null) ...[
            RoundedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top-up issue',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_error!),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _isProcessing ? null : _addFunds,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          PrimaryButton(
            label:
                '${_error == null ? 'Add' : 'Retry'} \$${(_parsedAmount ?? 0).toStringAsFixed(2)}',
            isLoading: _isProcessing,
            icon: Icons.account_balance_wallet_rounded,
            onPressed: _addFunds,
          ),
        ],
      ),
    );
  }
}
