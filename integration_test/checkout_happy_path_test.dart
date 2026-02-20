import 'package:discover_egypt/app/providers.dart';
import 'package:discover_egypt/core/services/payment_service.dart';
import 'package:discover_egypt/features/booking/confirm_pay_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';

class SuccessfulPaymentService extends PaymentService {
  @override
  Future<bool> processPayment({
    required double amount,
    required String currency,
    required String customerId,
    required String merchantName,
    String? description,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return true;
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('checkout happy-path navigates to success page', (tester) async {
    final router = GoRouter(
      initialLocation: '/confirm-pay',
      routes: [
        GoRoute(
          path: '/confirm-pay',
          builder: (context, state) => const ConfirmPayPage(),
        ),
        GoRoute(
          path: '/payment-success',
          builder: (context, state) => const Scaffold(
            body: Text('Payment Successful!'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paymentServiceProvider.overrideWithValue(SuccessfulPaymentService()),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), '4242424242424242');
    await tester.enterText(find.byType(TextField).at(1), '12/29');
    await tester.enterText(find.byType(TextField).at(2), '123');
    await tester.enterText(find.byType(TextField).at(3), 'Test User');

    await tester.tap(find.text('Pay \$410.40'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('Payment Successful!'), findsOneWidget);
  });
}
