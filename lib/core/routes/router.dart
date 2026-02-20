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

import '../../features/profile/profile_wallet_page.dart';
import '../../features/profile/edit_profile_page.dart';
import '../../features/profile/my_bookings_page.dart';

import '../../features/settings/settings_page.dart';

import '../../features/shared/trip_planner.dart';

final appRouter = GoRouter(
  initialLocation: '/cover',
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

    // Home
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => _buildPage(
        state,
        const HomePage(),
      ),
    ),

    // Hotels
    GoRoute(
      path: '/hotels',
      pageBuilder: (context, state) => _buildPage(
        state,
        const HotelsListPage(),
      ),
    ),
    GoRoute(
      path: '/hotel/:id',
      pageBuilder: (context, state) => _buildPage(
        state,
        HotelDetailsPage(id: state.pathParameters['id']!),
      ),
    ),

    // Tours
    GoRoute(
      path: '/tours',
      pageBuilder: (context, state) => _buildPage(
        state,
        const ToursListPage(),
      ),
    ),
    GoRoute(
      path: '/tour/:id',
      pageBuilder: (context, state) => _buildPage(
        state,
        TourDetailsPage(id: state.pathParameters['id']!),
      ),
    ),

    // Cars
    GoRoute(
      path: '/cars',
      pageBuilder: (context, state) => _buildPage(
        state,
        const CarsListPage(),
      ),
    ),
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
        const ConfirmPayPage(),
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
      path: '/profile',
      pageBuilder: (context, state) => _buildPage(
        state,
        const ProfileWalletPage(),
      ),
    ),
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
