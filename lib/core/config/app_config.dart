class AppConfig {
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

  // Enable social buttons only when native provider wiring is complete.
  static const bool enableGoogleAuth = bool.fromEnvironment(
    'ENABLE_GOOGLE_AUTH',
    defaultValue: false,
  );
  static const bool enableFacebookAuth = bool.fromEnvironment(
    'ENABLE_FACEBOOK_AUTH',
    defaultValue: false,
  );

  // Optional development-only token injection to exercise Firebase credential exchange.
  // In production, obtain these from native Google/Facebook SDK flows.
  static const String googleIdTokenForTesting = String.fromEnvironment(
    'GOOGLE_ID_TOKEN_FOR_TESTING',
    defaultValue: '',
  );
  static const String googleAccessTokenForTesting = String.fromEnvironment(
    'GOOGLE_ACCESS_TOKEN_FOR_TESTING',
    defaultValue: '',
  );
  static const String facebookAccessTokenForTesting = String.fromEnvironment(
    'FACEBOOK_ACCESS_TOKEN_FOR_TESTING',
    defaultValue: '',
  );

  static bool get hasStripePublishableKey =>
      stripePublishableKey.isNotEmpty && stripePublishableKey.startsWith('pk_');
}
