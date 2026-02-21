import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

import '../../features/profile/add_funds_page.dart';
import '../../features/profile/reviews_page.dart';
import '../../features/support/help_center_page.dart';
import '../../features/support/support_page.dart';
import '../../features/legal/privacy_policy_page.dart';
import '../../features/legal/terms_of_service_page.dart';

import '../../features/settings/settings_page.dart';

import '../../features/shared/trip_planner.dart';
import '../widgets/app_bottom_nav.dart';

GoRouter createAppRouter({
  List<NavigatorObserver> observers = const <NavigatorObserver>[],
}) {
  return GoRouter(
    observers: observers,
    initialLocation: '/home',
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

    GoRoute(
      path: '/reviews',
      pageBuilder: (context, state) => _buildPage(
        state,
        const ReviewsPage(),
      ),
    ),
    GoRoute(
      path: '/wallet/add-funds',
      pageBuilder: (context, state) => _buildPage(
        state,
        const AddFundsPage(),
      ),
    ),

    // Support & Legal
    GoRoute(
      path: '/help-center',
      pageBuilder: (context, state) => _buildPage(
        state,
        const HelpCenterPage(),
      ),
    ),
    GoRoute(
      path: '/support',
      pageBuilder: (context, state) => _buildPage(
        state,
        const SupportPage(),
      ),
    ),
    GoRoute(
      path: '/privacy-policy',
      pageBuilder: (context, state) => _buildPage(
        state,
        const PrivacyPolicyPage(),
      ),
    ),
    GoRoute(
      path: '/terms-of-service',
      pageBuilder: (context, state) => _buildPage(
        state,
        const TermsOfServicePage(),
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
      pageBuilder: (context, state) => _buildPage(
        state,
        const TripPlannerPage(),
      ),
    ),
    ],
  );
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
