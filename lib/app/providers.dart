import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/app_constants.dart';
import '../core/models/user_model.dart';
import '../core/navigation/navigation_tracking_observer.dart';
import '../core/routes/router.dart';
import '../core/services/auth_service.dart';
import '../core/services/database_service.dart';
import '../core/services/firebase_service.dart';
import '../core/services/payment_service.dart';

// Services
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final databaseServiceProvider =
    Provider<DatabaseService>((ref) => DatabaseService());
final paymentServiceProvider = Provider<PaymentService>((ref) => PaymentService());
final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());

// Navigation Tracking Consent Provider
final navigationTrackingConsentProvider =
    StateNotifierProvider<NavigationTrackingConsentNotifier, bool>((ref) {
  return NavigationTrackingConsentNotifier();
});

class NavigationTrackingConsentNotifier extends StateNotifier<bool> {
  NavigationTrackingConsentNotifier() : super(false) {
    _loadConsent();
  }

  void _loadConsent() {
    final box = Hive.box(AppConstants.settingsBox);
    state = box.get(
      AppConstants.navigationTrackingConsentKey,
      defaultValue: false,
    ) as bool;
  }

  void setConsent(bool consentGranted) {
    state = consentGranted;
    final box = Hive.box(AppConstants.settingsBox);
    box.put(AppConstants.navigationTrackingConsentKey, consentGranted);
  }
}

final navigationTrackingServiceProvider = Provider<NavigationTrackingService>((ref) {
  final service = NavigationTrackingService(
    firebaseService: ref.watch(firebaseServiceProvider),
    settingsBox: Hive.box(AppConstants.settingsBox),
  );

  ref.listen<bool>(navigationTrackingConsentProvider, (previous, next) {
    service.updateConsent(next);
  });

  ref.onDispose(service.dispose);

  return service;
});

final navigationTrackingObserverProvider =
    Provider<NavigationTrackingObserver>((ref) {
  return NavigationTrackingObserver(
    trackingService: ref.watch(navigationTrackingServiceProvider),
  );
});

final appRouterProvider = Provider<GoRouter>((ref) {
  return createAppRouter(
    observers: [ref.watch(navigationTrackingObserverProvider)],
  );
});

// Theme Mode Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final box = Hive.box(AppConstants.settingsBox);
    final themeIndex = box.get(AppConstants.themeKey, defaultValue: 0);
    state = ThemeMode.values[themeIndex];
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    final box = Hive.box(AppConstants.settingsBox);
    box.put(AppConstants.themeKey, mode.index);
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      setTheme(ThemeMode.dark);
    } else {
      setTheme(ThemeMode.light);
    }
  }
}

// Current User Provider
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, UserModel?>((ref) {
  return CurrentUserNotifier(ref.read(authServiceProvider));
});

class CurrentUserNotifier extends StateNotifier<UserModel?> {
  final AuthService _authService;

  CurrentUserNotifier(this._authService) : super(null) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = _authService.currentUser;
    if (user != null) {
      state = await _authService.getUserProfile(user.uid);
    }
  }

  void setUser(UserModel? user) {
    state = user;
  }

  Future<void> refreshUser() async {
    await _loadUser();
  }

  void clear() {
    state = null;
  }
}

// Language Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<Locale> {
  static const Set<String> _supportedLanguageCodes = {'en', 'ar', 'fr', 'de'};

  LanguageNotifier() : super(const Locale('en')) {
    _loadLanguage();
  }

  String _normalizeLanguageCode(String languageCode) {
    final normalized = languageCode.replaceAll('-', '_').split('_').first.toLowerCase();

    if (_supportedLanguageCodes.contains(normalized)) {
      return normalized;
    }

    return 'en';
  }

  void _loadLanguage() {
    final box = Hive.box(AppConstants.settingsBox);
    final languageCode = box.get(AppConstants.languageKey, defaultValue: 'en');
    final normalizedLanguageCode = _normalizeLanguageCode(languageCode);
    state = Locale(normalizedLanguageCode);

    if (normalizedLanguageCode != languageCode) {
      box.put(AppConstants.languageKey, normalizedLanguageCode);
    }
  }

  void setLanguage(String languageCode) {
    final normalizedLanguageCode = _normalizeLanguageCode(languageCode);
    state = Locale(normalizedLanguageCode);
    final box = Hive.box(AppConstants.settingsBox);
    box.put(AppConstants.languageKey, normalizedLanguageCode);
  }
}

// Onboarding Completed Provider
final onboardingCompletedProvider = StateProvider<bool>((ref) {
  final box = Hive.box(AppConstants.settingsBox);
  return box.get(AppConstants.onboardingKey, defaultValue: false);
});
