import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';

import '../../core/widgets/primary_button.dart';
import '../../core/widgets/rounded_card.dart';

class PaymentSuccessPage extends StatefulWidget {
  const PaymentSuccessPage({super.key});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green[600],
                      size: 80,
                    ),
                  )
                      .animate()
                      .scale(
                        delay: 200.ms,
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(),

                  const SizedBox(height: 32),

                  // Success Text
                  Text(
                    'Payment Successful!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

                  const SizedBox(height: 12),

                  Text(
                    'Your booking has been confirmed',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 600.ms, duration: 500.ms),

                  const SizedBox(height: 40),

                  // Booking Details Card
                  RoundedCard(
                    child: Column(
                      children: [
                        _DetailRow(
                          label: 'Booking ID',
                          value: '#BK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                        ),
                        const Divider(height: 24),
                        _DetailRow(
                          label: 'Amount Paid',
                          value: '\$410.40',
                          valueColor: const Color(0xFFC89B3C),
                        ),
                        const Divider(height: 24),
                        _DetailRow(
                          label: 'Payment Method',
                          value: 'Card ****3456',
                        ),
                        const Divider(height: 24),
                        _DetailRow(
                          label: 'Date',
                          value: DateTime.now().toString().substring(0, 10),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 800.ms, duration: 500.ms).slideY(begin: 0.2),

                  const Spacer(),

                  // Buttons
                  PrimaryButton(
                    label: 'View Booking',
                    icon: Icons.receipt_long_rounded,
                    onPressed: () => context.go('/my-bookings'),
                  ).animate().fadeIn(delay: 1000.ms, duration: 500.ms),

                  const SizedBox(height: 12),

                  PrimaryButton(
                    label: 'Back to Home',
                    icon: Icons.home_rounded,
                    isOutlined: true,
                    onPressed: () => context.go('/home'),
                  ).animate().fadeIn(delay: 1200.ms, duration: 500.ms),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.2,
              colors: const [
                Color(0xFFC89B3C),
                Colors.green,
                Colors.blue,
                Colors.red,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}