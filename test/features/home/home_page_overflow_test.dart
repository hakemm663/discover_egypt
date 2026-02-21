import 'package:discover_egypt/core/constants/image_urls.dart';
import 'package:discover_egypt/features/home/home_page.dart';
import 'package:discover_egypt/features/home/home_provider.dart';
import 'package:discover_egypt/features/shared/models/catalog_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Popular Hotels cards do not overflow on compact screens', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final compactData = HomeData(
      hotels: const [
        HotelListItem(
          id: '1',
          name: 'Very Long Hotel Name That Should Truncate Gracefully',
          city: 'Cairo',
          location: 'Very Long Location Name In Cairo Governorate, Egypt That Should Clip',
          image: Img.hotelLuxury,
          rating: 4.8,
          reviewCount: 999,
          price: 1234.0,
          stars: 5,
        ),
      ],
      tours: const [],
      recommendedTours: const [],
      destinations: const [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeDataProvider.overrideWith((ref) async => compactData),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    final dynamic exception = tester.takeException();
    expect(exception, isNull);

    expect(find.text('Popular Hotels'), findsOneWidget);
    expect(find.textContaining('Very Long Hotel Name'), findsOneWidget);
  });
}
