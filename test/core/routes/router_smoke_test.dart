import 'package:discover_egypt/core/models/booking_model.dart';
import 'package:discover_egypt/core/routes/router.dart';
import 'package:discover_egypt/features/booking/booking_checkout_data.dart';
import 'package:discover_egypt/features/booking/confirm_pay_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  BookingCheckoutData buildCheckoutData() {
    final now = DateTime(2026, 1, 10);
    return BookingCheckoutData(
      itemId: 'hotel_1',
      type: BookingType.hotel,
      itemName: 'Nile View Hotel',
      itemImage: 'https://example.com/hotel.jpg',
      startDate: now,
      endDate: now.add(const Duration(days: 2)),
      guestCount: 2,
      subtotal: 300,
      serviceFee: 25,
      taxes: 30,
      discount: 10,
      total: 345,
    );
  }

  testWidgets(
    '/confirm-pay resolves when state.extra is BookingCheckoutData',
    (tester) async {
      final router = createAppRouter();
      router.go('/confirm-pay', extra: buildCheckoutData());

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pump();

      expect(find.byType(ConfirmPayPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('/confirm-pay throws when state.extra is missing', (tester) async {
    final router = createAppRouter();

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isA<StateError>());
  });
}
