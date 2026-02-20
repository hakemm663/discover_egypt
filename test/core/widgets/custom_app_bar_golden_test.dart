import 'package:discover_egypt/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpBar(
    WidgetTester tester, {
    required String title,
    required bool showBackButton,
    required CustomAppBarVariant variant,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: CustomAppBar(
            title: title,
            showBackButton: showBackButton,
            showMenuButton: true,
            showProfileButton: true,
            variant: variant,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('snapshot: light app bar with back button', (tester) async {
    await pumpBar(
      tester,
      title: 'Light',
      showBackButton: true,
      variant: CustomAppBarVariant.light,
    );

    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);

    final title = tester.widget<Text>(find.text('Light'));
    expect(title.style?.color, Colors.black87);
  });

  testWidgets('snapshot: dark app bar without back button', (tester) async {
    await pumpBar(
      tester,
      title: 'Dark',
      showBackButton: false,
      variant: CustomAppBarVariant.dark,
    );

    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);
    expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);

    final title = tester.widget<Text>(find.text('Dark'));
    expect(title.style?.color, Colors.white);
  });
}
