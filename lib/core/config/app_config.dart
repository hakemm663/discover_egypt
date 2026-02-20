class AppConfig {
  // Inject with: --dart-define=API_BASE_URL=https://api.discoveregypt.com/v1
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  // Inject with: --dart-define=ENVIRONMENT=dev|stage|prod
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: '',
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

  static const Set<String> _allowedEnvironments = {'dev', 'stage', 'prod'};

  static bool get hasStripePublishableKey =>
      stripePublishableKey.isNotEmpty && stripePublishableKey.startsWith('pk_');

  static bool get hasApiBaseUrl => apiBaseUrl.trim().isNotEmpty;

  static bool get hasValidEnvironment =>
      _allowedEnvironments.contains(environment.trim().toLowerCase());

  static List<String> getValidationErrors() {
    final errors = <String>[];

    if (!hasApiBaseUrl) {
      errors.add('API_BASE_URL is required and cannot be empty.');
    }

    if (!hasValidEnvironment) {
      errors.add(
        'ENVIRONMENT must be one of: dev, stage, prod. Received: "${environment.isEmpty ? '<empty>' : environment}".',
      );
    }

    return errors;
  }
}
