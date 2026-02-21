import 'package:discover_egypt/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('perf smoke: scroll and navigate across core tabs', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: DiscoverEgyptApp()));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.fling(find.byType(Scrollable).first, const Offset(0, -500), 1200);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hotels'));
    await tester.pumpAndSettle();
    await tester.fling(find.byType(Scrollable).first, const Offset(0, -600), 1200);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tours'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cars'));
    await tester.pumpAndSettle();
  });
}
