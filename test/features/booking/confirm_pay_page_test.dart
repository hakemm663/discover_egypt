import 'package:discover_egypt/features/booking/checkout_payment_controller.dart';
import 'package:discover_egypt/features/booking/confirm_pay_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class TestNavigatorObserver extends NavigatorObserver {
  int didPushCount = 0;
  int didReplaceCount = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    didPushCount++;
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    didReplaceCount++;
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

void main() {
  late GoRouter router;
  late TestNavigatorObserver observer;

  setUp(() {
    observer = TestNavigatorObserver();

    router = GoRouter(
      initialLocation: '/confirm-pay',
      observers: [observer],
      routes: [
        GoRoute(
          path: '/confirm-pay',
          builder: (context, state) => const ConfirmPayPage(),
        ),
        GoRoute(
          path: '/payment-success',
          builder: (context, state) => const Scaffold(
            body: Text('Payment success destination'),
          ),
        ),
      ],
    );
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
  }

  CheckoutPaymentController readController(WidgetTester tester) {
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ConfirmPayPage)),
    );
    return container.read(checkoutPaymentControllerProvider.notifier);
  }

  testWidgets('shows and hides loading indicator based on controller state',
      (tester) async {
    await pumpPage(tester);

    expect(find.byType(CircularProgressIndicator), findsNothing);

    readController(tester).setStateForTest(
      const CheckoutPaymentState(status: CheckoutPaymentStatus.loading),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    readController(tester).setStateForTest(
      const CheckoutPaymentState(status: CheckoutPaymentStatus.idle),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows snackbar when controller emits error state', (tester) async {
    await pumpPage(tester);

    readController(tester).setStateForTest(
      const CheckoutPaymentState(
        status: CheckoutPaymentStatus.error,
        errorMessage: 'Payment failed: boom',
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Payment failed: boom'), findsOneWidget);
  });

  testWidgets('navigates to success route when controller emits success state',
      (tester) async {
    await pumpPage(tester);

    readController(tester).setStateForTest(
      const CheckoutPaymentState(status: CheckoutPaymentStatus.success),
    );
    await tester.pumpAndSettle();

    expect(find.text('Payment success destination'), findsOneWidget);
    expect(observer.didPushCount + observer.didReplaceCount, greaterThan(1));
  });
}
