import 'package:discover_egypt/core/models/user_model.dart';
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

    test('redirects vendor users from tourist home to vendor dashboard', () {
      final redirect = resolveAppRedirect(
        location: '/home',
        isAuthenticated: true,
        onboardingCompleted: true,
        currentRole: AppUserRole.vendor,
      );

      expect(redirect, '/vendor/dashboard');
    });

    test('blocks tourists from admin routes', () {
      final redirect = resolveAppRedirect(
        location: '/admin/dashboard',
        isAuthenticated: true,
        onboardingCompleted: true,
        currentRole: AppUserRole.tourist,
      );

      expect(redirect, '/home');
    });
  });
}
