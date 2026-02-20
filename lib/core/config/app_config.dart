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

  static bool get hasStripePublishableKey =>
      stripePublishableKey.isNotEmpty && stripePublishableKey.startsWith('pk_');
}
