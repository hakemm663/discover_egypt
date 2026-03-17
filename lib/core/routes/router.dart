import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/screens/admin_dashboard_page.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/booking/booking_checkout_data.dart';
import '../../features/booking/presentation/screens/booking_summary_screen.dart';
import '../../features/booking/presentation/screens/confirm_payment_screen.dart';
import '../../features/booking/presentation/screens/payment_success_screen.dart';
import '../../features/cars/car_details_page.dart';
import '../../features/cars/cars_list_page.dart';
import '../../features/home/home_page.dart';
import '../../features/hotels/hotel_details_page.dart';
import '../../features/hotels/hotels_list_page.dart';
import '../../features/itinerary/presentation/screens/itinerary_planner_screen.dart';
import '../../features/legal/privacy_policy_page.dart';
import '../../features/legal/terms_of_service_page.dart';
import '../../features/listings/presentation/screens/listing_detail_page.dart';
import '../../features/marketplace/presentation/screens/marketplace_page.dart';
import '../../features/onboarding/cover_page.dart';
import '../../features/onboarding/interests_page.dart';
import '../../features/onboarding/language_page.dart';
import '../../features/onboarding/nationality_page.dart';
import '../../features/profile/add_funds_page.dart';
import '../../features/profile/edit_profile_page.dart';
import '../../features/profile/my_bookings_page.dart';
import '../../features/profile/profile_wallet_page.dart';
import '../../features/profile/reviews_page.dart';
import '../../features/restaurants/restaurant_details_page.dart';
import '../../features/restaurants/restaurants_list_page.dart';
import '../../features/search/presentation/screens/search_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/staff/presentation/screens/staff_dashboard_page.dart';
import '../../features/support/help_center_page.dart';
import '../../features/support/support_page.dart';
import '../../features/tours/tour_details_page.dart';
import '../../features/tours/tours_list_page.dart';
import '../../features/vendor/presentation/screens/vendor_dashboard_page.dart';
import '../../features/vendor/presentation/screens/vendor_listing_editor_page.dart';
import '../models/user_model.dart';
import '../widgets/app_bottom_nav.dart';

const Set<String> _onboardingRoutes = {
  '/cover',
  '/language',
  '/nationality',
  '/interests',
};

const Set<String> _authRoutes = {
  '/sign-in',
  '/sign-up',
  '/forgot-password',
};

const Set<String> _roleAwareHomeRoutes = {
  '/',
  '/home',
};

String defaultHomeForRole(AppUserRole role) {
  switch (role) {
    case AppUserRole.tourist:
      return '/home';
    case AppUserRole.vendor:
      return '/vendor/dashboard';
    case AppUserRole.admin:
      return '/admin/dashboard';
    case AppUserRole.staff:
      return '/staff/dashboard';
  }
}

String? resolveAppRedirect({
  required String location,
  required bool isAuthenticated,
  required bool onboardingCompleted,
  AppUserRole currentRole = AppUserRole.tourist,
}) {
  final isOnboardingRoute = _onboardingRoutes.contains(location);
  final isAuthRoute = _authRoutes.contains(location);

  if (location == '/') {
    return !onboardingCompleted
        ? '/cover'
        : isAuthenticated
            ? defaultHomeForRole(currentRole)
            : '/sign-in';
  }

  if (!onboardingCompleted && !isOnboardingRoute) {
    return '/cover';
  }

  if (onboardingCompleted && isOnboardingRoute) {
    return isAuthenticated ? defaultHomeForRole(currentRole) : '/sign-in';
  }

  if (!isAuthenticated && onboardingCompleted && !isAuthRoute) {
    return '/sign-in';
  }

  if (isAuthenticated && isAuthRoute) {
    return defaultHomeForRole(currentRole);
  }

  if (isAuthenticated &&
      currentRole != AppUserRole.tourist &&
      _roleAwareHomeRoutes.contains(location)) {
    return defaultHomeForRole(currentRole);
  }

  if (location.startsWith('/vendor') &&
      currentRole != AppUserRole.vendor &&
      currentRole != AppUserRole.admin) {
    return defaultHomeForRole(currentRole);
  }

  if (location.startsWith('/admin') && currentRole != AppUserRole.admin) {
    return defaultHomeForRole(currentRole);
  }

  if (location.startsWith('/staff') &&
      currentRole != AppUserRole.staff &&
      currentRole != AppUserRole.admin) {
    return defaultHomeForRole(currentRole);
  }

  return null;
}

GoRouter createAppRouter({
  required bool isAuthenticated,
  required bool onboardingCompleted,
  AppUserRole currentRole = AppUserRole.tourist,
  String initialLocation = '/home',
  List<NavigatorObserver> observers = const <NavigatorObserver>[],
  Listenable? refreshListenable,
}) {
  return GoRouter(
    observers: observers,
    refreshListenable: refreshListenable,
    initialLocation: initialLocation,
    redirect: (context, state) {
      return resolveAppRedirect(
        location: state.uri.path,
        isAuthenticated: isAuthenticated,
        onboardingCompleted: onboardingCompleted,
        currentRole: currentRole,
      );
    },
    routes: [
      GoRoute(
        path: '/cover',
        pageBuilder: (context, state) => _buildPage(state, const CoverPage()),
      ),
      GoRoute(
        path: '/language',
        pageBuilder: (context, state) =>
            _buildPage(state, const LanguagePage()),
      ),
      GoRoute(
        path: '/nationality',
        pageBuilder: (context, state) =>
            _buildPage(state, const NationalityPage()),
      ),
      GoRoute(
        path: '/interests',
        pageBuilder: (context, state) =>
            _buildPage(state, const InterestsPage()),
      ),
      GoRoute(
        path: '/sign-in',
        pageBuilder: (context, state) => _buildPage(state, const SignInScreen()),
      ),
      GoRoute(
        path: '/sign-up',
        pageBuilder: (context, state) => _buildPage(state, const SignUpScreen()),
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) =>
            _buildPage(state, const ForgotPasswordScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppBottomNavShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) =>
                    _buildPage(state, const HomePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                pageBuilder: (context, state) =>
                    _buildPage(state, const SearchPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/marketplace',
                pageBuilder: (context, state) =>
                    _buildPage(state, const MarketplacePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/itinerary',
                pageBuilder: (context, state) =>
                    _buildPage(state, const ItineraryPlannerScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) =>
                    _buildPage(state, const ProfileWalletPage()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/hotels',
        pageBuilder: (context, state) =>
            _buildPage(state, const HotelsListPage()),
      ),
      GoRoute(
        path: '/tours',
        pageBuilder: (context, state) =>
            _buildPage(state, const ToursListPage()),
      ),
      GoRoute(
        path: '/cars',
        pageBuilder: (context, state) => _buildPage(state, const CarsListPage()),
      ),
      GoRoute(
        path: '/restaurants',
        pageBuilder: (context, state) =>
            _buildPage(state, const RestaurantsListPage()),
      ),
      GoRoute(
        path: '/hotel/:id',
        pageBuilder: (context, state) => _buildPage(
          state,
          HotelDetailsPage(id: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/tour/:id',
        pageBuilder: (context, state) => _buildPage(
          state,
          TourDetailsPage(id: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/car/:id',
        pageBuilder: (context, state) => _buildPage(
          state,
          CarDetailsPage(id: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/restaurant/:id',
        pageBuilder: (context, state) => _buildPage(
          state,
          RestaurantDetailsPage(id: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/marketplace/listing/:category/:id',
        pageBuilder: (context, state) => _buildPage(
          state,
          ListingDetailPage(
            category: state.pathParameters['category']!,
            listingId: state.pathParameters['id']!,
          ),
        ),
      ),
      GoRoute(
        path: '/booking-summary',
        pageBuilder: (context, state) =>
            _buildPage(state, const BookingSummaryScreen()),
      ),
      GoRoute(
        path: '/confirm-pay',
        pageBuilder: (context, state) => _buildPage(
          state,
          ConfirmPaymentScreen(
            checkoutData: _checkoutDataFromState(state),
          ),
        ),
      ),
      GoRoute(
        path: '/payment-success',
        pageBuilder: (context, state) =>
            _buildPage(state, const PaymentSuccessScreen()),
      ),
      GoRoute(
        path: '/vendor/dashboard',
        pageBuilder: (context, state) =>
            _buildPage(state, const VendorDashboardPage()),
      ),
      GoRoute(
        path: '/vendor/listings/new',
        pageBuilder: (context, state) =>
            _buildPage(state, const VendorListingEditorPage()),
      ),
      GoRoute(
        path: '/vendor/listings/:id/edit',
        pageBuilder: (context, state) => _buildPage(
          state,
          VendorListingEditorPage(
            listingId: state.pathParameters['id'],
          ),
        ),
      ),
      GoRoute(
        path: '/admin/dashboard',
        pageBuilder: (context, state) =>
            _buildPage(state, const AdminDashboardPage()),
      ),
      GoRoute(
        path: '/staff/dashboard',
        pageBuilder: (context, state) =>
            _buildPage(state, const StaffDashboardPage()),
      ),
      GoRoute(
        path: '/edit-profile',
        pageBuilder: (context, state) =>
            _buildPage(state, const EditProfilePage()),
      ),
      GoRoute(
        path: '/my-bookings',
        pageBuilder: (context, state) =>
            _buildPage(state, const MyBookingsPage()),
      ),
      GoRoute(
        path: '/reviews',
        pageBuilder: (context, state) =>
            _buildPage(state, const ReviewsPage()),
      ),
      GoRoute(
        path: '/wallet/add-funds',
        pageBuilder: (context, state) =>
            _buildPage(state, const AddFundsPage()),
      ),
      GoRoute(
        path: '/help-center',
        pageBuilder: (context, state) => _buildPage(
          state,
          HelpCenterPage(topic: state.uri.queryParameters['topic']),
        ),
      ),
      GoRoute(
        path: '/support',
        pageBuilder: (context, state) =>
            _buildPage(state, const SupportPage()),
      ),
      GoRoute(
        path: '/privacy-policy',
        pageBuilder: (context, state) =>
            _buildPage(state, const PrivacyPolicyPage()),
      ),
      GoRoute(
        path: '/terms-of-service',
        pageBuilder: (context, state) =>
            _buildPage(state, const TermsOfServicePage()),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) =>
            _buildPage(state, const SettingsPage()),
      ),
      GoRoute(
        path: '/trip-planner',
        pageBuilder: (context, state) =>
            _buildPage(state, const ItineraryPlannerScreen()),
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
