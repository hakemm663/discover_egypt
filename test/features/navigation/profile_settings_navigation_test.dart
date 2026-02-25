import 'dart:io';

import 'package:discover_egypt/app/providers.dart';
import 'package:discover_egypt/core/constants/app_constants.dart';
import 'package:discover_egypt/core/models/user_model.dart';
import 'package:discover_egypt/core/routes/router.dart';
import 'package:discover_egypt/features/profile/profile_wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('discover_egypt_nav_test');
    Hive.init(tempDir.path);
    await Hive.openBox(AppConstants.settingsBox);
  });

  tearDown(() async {
    await Hive.box(AppConstants.settingsBox).clear();
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  Widget createTestApp() {
    final user = UserModel(
      id: 'user-1',
      email: 'traveler@example.com',
      fullName: 'Traveler',
      nationality: 'Egypt',
      createdAt: DateTime(2024, 1, 1),
    );

    return ProviderScope(
      overrides: [
        currentUserProvider.overrideWith((ref) => Stream.value(user)),
        appRouterProvider.overrideWithValue(createAppRouter()),
      ],
      child: Consumer(
        builder: (context, ref, _) => MaterialApp.router(
          routerConfig: ref.watch(appRouterProvider),
        ),
      ),
    );
  }

  testWidgets('Profile menu navigates to reviews, support, and settings pages', (tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileWalletPage), findsOneWidget);

    await tester.tap(find.text('Reviews'));
    await tester.pumpAndSettle();
    expect(find.text('My Reviews'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Support'));
    await tester.pumpAndSettle();
    expect(find.text('Submit a ticket'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Notifications'), findsOneWidget);
  });

  testWidgets('Settings page navigates to help center and legal pages', (tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Help Center'));
    await tester.pumpAndSettle();
    expect(find.text('Help Center'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Privacy Policy'));
    await tester.pumpAndSettle();
    expect(find.text('Privacy Policy'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Terms of Service'));
    await tester.pumpAndSettle();
    expect(find.text('Terms of Service'), findsOneWidget);
  });
}
