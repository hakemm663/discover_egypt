class AppConstants {
  // App Info
  static const String appName = 'Discover Egypt';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Storage Keys
  static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String onboardingKey = 'onboarding_completed';
  static const String userTokenKey = 'user_token';

  // API Keys (Use environment variables in production)
  static const String stripePublishableKey = 'pk_test_demo_key_replace_with_real';
  static const String stripeSecretKey = 'sk_test_demo_key_replace_with_real';
  static const String googleMapsApiKey = 'AIzaSyDemo_key_replace_with_real';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String hotelsCollection = 'hotels';
  static const String toursCollection = 'tours';
  static const String carsCollection = 'cars';
  static const String restaurantsCollection = 'restaurants';
  static const String bookingsCollection = 'bookings';
  static const String reviewsCollection = 'reviews';

  // Booking Types
  static const String bookingHotel = 'hotel';
  static const String bookingTour = 'tour';
  static const String bookingCar = 'car';
  static const String bookingRestaurant = 'restaurant';

  // Commission Rates
  static const double hotelCommission = 0.12; // 12%
  static const double tourCommission = 0.15; // 15%
  static const double carCommission = 0.10; // 10%
  static const double restaurantCommission = 0.08; // 8%
}