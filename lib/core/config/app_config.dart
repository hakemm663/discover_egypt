class AppConfig {
  // Inject with: --dart-define=APP_ENV=production
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'production',
  );

  // Inject with: --dart-define=BASE_URL=https://api.discoveregypt.com/v1
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.discoveregypt.com/v1',
  );

  // Inject with: --dart-define=DISCOVERY_FALLBACK_ENABLED=true
  static const bool discoveryFallbackEnabled = bool.fromEnvironment(
    'DISCOVERY_FALLBACK_ENABLED',
    defaultValue: false,
  );

  // Inject with: --dart-define=GOOGLE_SIGN_IN_ENABLED=true
  static const bool googleSignInEnabled = bool.fromEnvironment(
    'GOOGLE_SIGN_IN_ENABLED',
    defaultValue: true,
  );

  // Inject with: --dart-define=FACEBOOK_SIGN_IN_ENABLED=false
  static const bool facebookSignInEnabled = bool.fromEnvironment(
    'FACEBOOK_SIGN_IN_ENABLED',
    defaultValue: false,
  );

  // Inject with: --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_xxx
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: '',
  );

  // Inject with: --dart-define=GOOGLE_MAPS_API_KEY=AIza...
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  static bool get hasStripePublishableKey =>
      stripePublishableKey.isNotEmpty && stripePublishableKey.startsWith('pk_');
}
