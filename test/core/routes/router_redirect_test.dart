import 'package:discover_egypt/core/routes/router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveAppRedirect', () {
    test('redirects first run users to cover', () {
      final redirect = resolveAppRedirect(
        location: '/home',
        isAuthenticated: false,
        onboardingCompleted: false,
      );

      expect(redirect, '/cover');
    });

    test('allows onboarding flow when first run', () {
      final redirect = resolveAppRedirect(
        location: '/language',
        isAuthenticated: false,
        onboardingCompleted: false,
      );

      expect(redirect, isNull);
    });

    test('redirects unauthenticated users to sign-in after onboarding', () {
      final redirect = resolveAppRedirect(
        location: '/hotels',
        isAuthenticated: false,
        onboardingCompleted: true,
      );

      expect(redirect, '/sign-in');
    });

    test('redirects authenticated users away from auth routes', () {
      final redirect = resolveAppRedirect(
        location: '/sign-in',
        isAuthenticated: true,
        onboardingCompleted: true,
      );

      expect(redirect, '/home');
    });

    test('allows authenticated users to access app routes', () {
      final redirect = resolveAppRedirect(
        location: '/trip-planner',
        isAuthenticated: true,
        onboardingCompleted: true,
      );

      expect(redirect, isNull);
    });
  });
}
