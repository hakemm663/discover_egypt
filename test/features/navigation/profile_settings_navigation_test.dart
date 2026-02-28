import 'dart:io';

import 'package:discover_egypt/app/providers.dart';
import 'package:discover_egypt/core/constants/app_constants.dart';
import 'package:discover_egypt/core/models/user_model.dart';
import 'package:discover_egypt/core/routes/router.dart';
import 'package:discover_egypt/features/auth/sign_in_page.dart';
import 'package:discover_egypt/features/home/home_page.dart';
import 'package:discover_egypt/features/onboarding/cover_page.dart';
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

  Widget createTestApp({
    bool isAuthenticated = true,
    bool onboardingCompleted = true,
  }) {
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
        appRouterProvider.overrideWithValue(
          createAppRouter(
            isAuthenticated: isAuthenticated,
            onboardingCompleted: onboardingCompleted,
          ),
        ),
      ],
      child: Consumer(
        builder: (context, ref, _) => MaterialApp.router(
          routerConfig: ref.watch(appRouterProvider),
        ),
      ),
    );
  }

  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> tapBackButton(WidgetTester tester) async {
    final backButton = find.byIcon(Icons.arrow_back_ios_new_rounded).hitTestable();
    expect(backButton, findsWidgets);
    await tester.tap(backButton.first);
    await tester.pumpAndSettle();
  }

  Future<void> scrollAndTap(WidgetTester tester, String label) async {
    final target = find.text(label);
    if (target.hitTestable().evaluate().isEmpty) {
      final scrollable = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(target, 200, scrollable: scrollable);
      await tester.pumpAndSettle();
    }

    await tester.tap(target.hitTestable().first);
    await tester.pumpAndSettle();
  }

  testWidgets('Profile menu navigates to reviews, support, and settings pages', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(ProfileWalletPage), findsOneWidget);

    await scrollAndTap(tester, 'Reviews');
    expect(find.text('My Reviews'), findsOneWidget);
    await tapBackButton(tester);

    await scrollAndTap(tester, 'Support');
    expect(find.text('Submit a ticket'), findsOneWidget);
    await tapBackButton(tester);

    await scrollAndTap(tester, 'Settings');
    expect(find.text('Notifications'), findsOneWidget);
  });

  testWidgets('Settings page navigates to help center and legal pages', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    await scrollAndTap(tester, 'Settings');

    await scrollAndTap(tester, 'Help Center');
    expect(find.text('Help Center'), findsOneWidget);
    await tapBackButton(tester);

    await scrollAndTap(tester, 'Privacy Policy');
    expect(find.text('Privacy Policy'), findsOneWidget);
    await tapBackButton(tester);

    await scrollAndTap(tester, 'Terms of Service');
    expect(find.text('Terms of Service'), findsOneWidget);
  });

  testWidgets('redirects to cover when onboarding is not completed', (tester) async {
    await tester.pumpWidget(
      createTestApp(isAuthenticated: true, onboardingCompleted: false),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CoverPage), findsOneWidget);
  });

  testWidgets('redirects unauthenticated users to sign-in after onboarding', (tester) async {
    await tester.pumpWidget(
      createTestApp(isAuthenticated: false, onboardingCompleted: true),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SignInPage), findsOneWidget);
  });


  testWidgets('allows unauthenticated users on auth routes after onboarding', (tester) async {
    final router = createAppRouter(
      isAuthenticated: false,
      onboardingCompleted: true,
    );
    router.go('/sign-in');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appRouterProvider.overrideWithValue(router),
        ],
        child: Consumer(
          builder: (context, ref, _) => MaterialApp.router(
            routerConfig: ref.watch(appRouterProvider),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SignInPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });
  testWidgets('redirects authenticated users away from auth routes', (tester) async {
    final router = createAppRouter(
      isAuthenticated: true,
      onboardingCompleted: true,
    );
    router.go('/sign-in');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appRouterProvider.overrideWithValue(router),
        ],
        child: Consumer(
          builder: (context, ref, _) => MaterialApp.router(
            routerConfig: ref.watch(appRouterProvider),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(SignInPage), findsNothing);
  });
}
