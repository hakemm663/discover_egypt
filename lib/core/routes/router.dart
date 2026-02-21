import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../../features/onboarding/cover_page.dart';
import '../../features/onboarding/language_page.dart';
import '../../features/onboarding/nationality_page.dart';
import '../../features/onboarding/interests_page.dart';

import '../../features/auth/sign_in_page.dart';
import '../../features/auth/sign_up_page.dart';
import '../../features/auth/forgot_password_page.dart';

import '../../features/home/home_page.dart';

import '../../features/hotels/hotels_list_page.dart';
import '../../features/hotels/hotel_details_page.dart';

import '../../features/tours/tours_list_page.dart';
import '../../features/tours/tour_details_page.dart';

import '../../features/cars/cars_list_page.dart';
import '../../features/cars/car_details_page.dart';

import '../../features/restaurants/restaurants_list_page.dart';
import '../../features/restaurants/restaurant_details_page.dart';

import '../../features/booking/booking_summary_page.dart';
import '../../features/booking/confirm_pay_page.dart';
import '../../features/booking/payment_success_page.dart';
import '../../features/booking/booking_checkout_data.dart';

import '../../features/profile/profile_wallet_page.dart';
import '../../features/profile/edit_profile_page.dart';
import '../../features/profile/my_bookings_page.dart';

import '../../features/settings/settings_page.dart';

import '../../features/shared/trip_planner.dart';
import '../widgets/app_bottom_nav.dart';

final _authService = AuthService();

final appRouter = GoRouter(
  initialLocation: '/home',
  refreshListenable: _AuthRouterRefreshStream(_authService.authStateChanges),
  redirect: (context, state) {
    final isSignedIn = _authService.currentUser != null;
    final path = state.uri.path;

    const authRoutes = {'/sign-in', '/sign-up', '/forgot-password'};
    final isAuthRoute = authRoutes.contains(path);

    final isShellRoute = {
      '/home',
      '/hotels',
      '/tours',
      '/cars',
      '/profile',
      '/restaurants',
      '/booking-summary',
      '/confirm-pay',
      '/payment-success',
      '/edit-profile',
      '/my-bookings',
      '/settings',
      '/trip-planner',
    }.contains(path) ||
        path.startsWith('/hotel/') ||
        path.startsWith('/tour/') ||
        path.startsWith('/car/') ||
        path.startsWith('/restaurant/');

    if (!isSignedIn && isShellRoute) {
      return '/sign-in';
    }

    if (isSignedIn && isAuthRoute) {
      return '/home';
    }

    return null;
  },
  routes: [
    // Onboarding
    GoRoute(
      path: '/cover',
      pageBuilder: (context, state) => _buildPage(
        state,
        const CoverPage(),
      ),
    ),
    GoRoute(
      path: '/language',
      pageBuilder: (context, state) => _buildPage(
        state,
        const LanguagePage(),
      ),
    ),
    GoRoute(
      path: '/nationality',
      pageBuilder: (context, state) => _buildPage(
        state,
        const NationalityPage(),
      ),
    ),
    GoRoute(
      path: '/interests',
      pageBuilder: (context, state) => _buildPage(
        state,
        const InterestsPage(),
      ),
    ),

    // Auth
    GoRoute(
      path: '/sign-in',
      pageBuilder: (context, state) => _buildPage(
        state,
        const SignInPage(),
      ),
    ),
    GoRoute(
      path: '/sign-up',
      pageBuilder: (context, state) => _buildPage(
        state,
        const SignUpPage(),
      ),
    ),
    GoRoute(
      path: '/forgot-password',
      pageBuilder: (context, state) => _buildPage(
        state,
        const ForgotPasswordPage(),
      ),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppBottomNavShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => _buildPage(
                state,
                const HomePage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/hotels',
              pageBuilder: (context, state) => _buildPage(
                state,
                const HotelsListPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tours',
              pageBuilder: (context, state) => _buildPage(
                state,
                const ToursListPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cars',
              pageBuilder: (context, state) => _buildPage(
                state,
                const CarsListPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => _buildPage(
                state,
                const ProfileWalletPage(),
              ),
            ),
          ],
        ),
      ],
    ),

    // Hotels
    GoRoute(
      path: '/hotel/:id',
      pageBuilder: (context, state) => _buildPage(
        state,
        HotelDetailsPage(id: state.pathParameters['id']!),
      ),
    ),

    // Tours
    GoRoute(
      path: '/tour/:id',
      pageBuilder: (context, state) => _buildPage(
        state,
        TourDetailsPage(id: state.pathParameters['id']!),
      ),
    ),

    // Cars
    GoRoute(
      path: '/car/:id',
      pageBuilder: (context, state) => _buildPage(
        state,
        CarDetailsPage(id: state.pathParameters['id']!),
      ),
    ),

    // Restaurants
    GoRoute(
      path: '/restaurants',
      pageBuilder: (context, state) => _buildPage(
        state,
        const RestaurantsListPage(),
      ),
    ),
    GoRoute(
      path: '/restaurant/:id',
      pageBuilder: (context, state) => _buildPage(
        state,
        RestaurantDetailsPage(id: state.pathParameters['id']!),
      ),
    ),

    // Booking
    GoRoute(
      path: '/booking-summary',
      pageBuilder: (context, state) => _buildPage(
        state,
        const BookingSummaryPage(),
      ),
    ),
    GoRoute(
      path: '/confirm-pay',
      pageBuilder: (context, state) => _buildPage(
        state,
        ConfirmPayPage(checkoutData: _checkoutDataFromState(state)),
      ),
    ),
    GoRoute(
      path: '/payment-success',
      pageBuilder: (context, state) => _buildPage(
        state,
        const PaymentSuccessPage(),
      ),
    ),

    // Profile
    GoRoute(
      path: '/edit-profile',
      pageBuilder: (context, state) => _buildPage(
        state,
        const EditProfilePage(),
      ),
    ),
    GoRoute(
      path: '/my-bookings',
      pageBuilder: (context, state) => _buildPage(
        state,
        const MyBookingsPage(),
      ),
    ),

    // Settings
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => _buildPage(
        state,
        const SettingsPage(),
      ),
    ),

    // Trip Planner
    GoRoute(
      path: '/trip-planner',
      builder: (context, state) => const TripPlannerPage(),
    ),
  ],
);

class _AuthRouterRefreshStream extends ChangeNotifier {
  _AuthRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

CustomTransitionPage _buildPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}

BookingCheckoutData _checkoutDataFromState(GoRouterState state) {
  final extra = state.extra;
  if (extra is BookingCheckoutData) {
    return extra;
  }

  throw StateError('Missing checkout data for /confirm-pay route.');
}
