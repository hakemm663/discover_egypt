enum AppEnvironment { dev, staging, prod }

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

  // Inject with: --dart-define=BASE_URL=https://api.example.com
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.discoveregypt.com/v1',
  );

  // Inject with: --dart-define=DISCOVERY_FALLBACK_ENABLED=true|false
  static const String discoveryFallbackEnabledRaw = String.fromEnvironment(
    'DISCOVERY_FALLBACK_ENABLED',
    defaultValue: _autoBool,
  );

  // Inject with: --dart-define=GOOGLE_SIGN_IN_ENABLED=true|false
  static const String googleSignInEnabledRaw = String.fromEnvironment(
    'GOOGLE_SIGN_IN_ENABLED',
    defaultValue: 'false',
  );

  // Inject with: --dart-define=FACEBOOK_SIGN_IN_ENABLED=true|false
  static const String facebookSignInEnabledRaw = String.fromEnvironment(
    'FACEBOOK_SIGN_IN_ENABLED',
    defaultValue: 'false',
  );

  static AppEnvironment get environment {
    switch (appEnvRaw.toLowerCase()) {
      case 'dev':
        return AppEnvironment.dev;
      case 'staging':
        return AppEnvironment.staging;
      case 'prod':
      default:
        return AppEnvironment.prod;
    }
  }

  static bool get isDiscoveryFallbackEnabled {
    final raw = discoveryFallbackEnabledRaw.toLowerCase();
    if (raw == 'true') return true;
    if (raw == 'false') return false;
    return environment != AppEnvironment.prod;
  }

  static bool get isGoogleSignInEnabled =>
      googleSignInEnabledRaw.toLowerCase() == 'true';

  static bool get isFacebookSignInEnabled =>
      facebookSignInEnabledRaw.toLowerCase() == 'true';

  static bool get hasStripePublishableKey =>
      stripePublishableKey.isNotEmpty && stripePublishableKey.startsWith('pk_');

  static bool get hasGoogleMapsApiKey => googleMapsApiKey.isNotEmpty;
}
