enum AppEnvironment { dev, staging, prod }

class AppConfig {
  static const String _autoBool = '__auto__';

  // Inject with: --dart-define=APP_ENV=dev|staging|prod
  static const String appEnvRaw = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'prod',
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
