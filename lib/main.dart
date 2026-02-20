import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/constants/app_constants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _validateRuntimeConfig();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase initialization error: $e');
    // Continue app execution even if Firebase fails
  }

  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.settingsBox);
  await Hive.openBox(AppConstants.cacheBox);

  // Initialize Stripe with publishable key only
  try {
    if (AppConfig.hasStripePublishableKey) {
      Stripe.publishableKey = AppConfig.stripePublishableKey;
      await Stripe.instance.applySettings();
    } else {
      debugPrint('⚠️ Stripe publishable key is missing or invalid');
    }
  } catch (e) {
    debugPrint('Stripe initialization error: $e');
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ProviderScope(child: DiscoverEgyptApp()));
}

void _validateRuntimeConfig() {
  final configErrors = AppConfig.getValidationErrors();

  if (configErrors.isEmpty) {
    debugPrint(
      '✅ Runtime config loaded (environment: ${AppConfig.environment}, apiBaseUrl: ${AppConfig.apiBaseUrl})',
    );
    return;
  }

  debugPrint('❌ Runtime configuration validation failed:');
  for (final error in configErrors) {
    debugPrint('   • $error');
  }
  debugPrint(
    'ℹ️ Pass required values via --dart-define (e.g. --dart-define=ENVIRONMENT=dev --dart-define=API_BASE_URL=https://api-dev.discoveregypt.com/v1).',
  );

  if (kReleaseMode) {
    throw StateError(
      'Missing required runtime configuration for release build. Check startup logs for details.',
    );
  }
}
