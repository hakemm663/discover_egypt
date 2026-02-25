import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/app_constants.dart';
import '../core/models/user_model.dart';
import '../core/navigation/navigation_tracking_observer.dart';
import '../core/repositories/api_clients/discovery_api_clients.dart';
import '../core/repositories/discovery_repositories.dart';
import '../core/repositories/firestore/discovery_firestore_client.dart';
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

class NotificationPreferences {
  const NotificationPreferences({
    this.pushEnabled = true,
    this.emailEnabled = false,
    this.promotionsEnabled = true,
  });

  final bool pushEnabled;
  final bool emailEnabled;
  final bool promotionsEnabled;

  NotificationPreferences copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? promotionsEnabled,
  }) {
    return NotificationPreferences(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      promotionsEnabled: promotionsEnabled ?? this.promotionsEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'push': pushEnabled,
      'email': emailEnabled,
      'promotions': promotionsEnabled,
      'updatedAt': Timestamp.now(),
    };
  }

  Map<String, dynamic> toLocalJson() {
    return {
      'push': pushEnabled,
      'email': emailEnabled,
      'promotions': promotionsEnabled,
    };
  }

  static NotificationPreferences fromLocal(dynamic value) {
    if (value is! Map) {
      return const NotificationPreferences();
    }

    final map = Map<String, dynamic>.from(value.cast<dynamic, dynamic>());
    return NotificationPreferences(
      pushEnabled: map['push'] == true,
      emailEnabled: map['email'] == true,
      promotionsEnabled: map['promotions'] != false,
    );
  }
}

final notificationPreferencesProvider = StateNotifierProvider<
    NotificationPreferencesNotifier, NotificationPreferences>((ref) {
  return NotificationPreferencesNotifier(
    authService: ref.read(authServiceProvider),
    firestore: FirebaseFirestore.instance,
  );
});

class NotificationPreferencesNotifier
    extends StateNotifier<NotificationPreferences> {
  NotificationPreferencesNotifier({
    required AuthService authService,
    required FirebaseFirestore firestore,
  })  : _authService = authService,
        _firestore = firestore,
        super(const NotificationPreferences()) {
    _loadPreferences();
  }

  final AuthService _authService;
  final FirebaseFirestore _firestore;

  void _loadPreferences() {
    final box = Hive.box(AppConstants.settingsBox);
    state = NotificationPreferences.fromLocal(
      box.get(AppConstants.notificationPreferencesKey),
    );
  }

  Future<void> setPreferences(NotificationPreferences preferences) async {
    state = preferences;

    final box = Hive.box(AppConstants.settingsBox);
    await box.put(
      AppConstants.notificationPreferencesKey,
      preferences.toLocalJson(),
    );

    final user = _authService.currentUser;
    if (user == null) return;

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set({'notificationPreferences': preferences.toJson()}, SetOptions(merge: true));
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

final hotelsApiClientProvider = Provider<HotelsApiClient>((ref) => HotelsApiClient());
final toursApiClientProvider = Provider<ToursApiClient>((ref) => ToursApiClient());
final carsApiClientProvider = Provider<CarsApiClient>((ref) => CarsApiClient());
final restaurantsApiClientProvider = Provider<RestaurantsApiClient>((ref) => RestaurantsApiClient());
final discoveryFirestoreClientProvider =
    Provider<DiscoveryFirestoreClient>((ref) => DiscoveryFirestoreClient());

final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  return DiscoveryRepository(
    hotelsApiClient: ref.read(hotelsApiClientProvider),
    toursApiClient: ref.read(toursApiClientProvider),
    carsApiClient: ref.read(carsApiClientProvider),
    restaurantsApiClient: ref.read(restaurantsApiClientProvider),
    firestoreClient: ref.read(discoveryFirestoreClientProvider),
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

// Auth + Current User Providers
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final controller = StreamController<UserModel?>();
  final firestore = FirebaseFirestore.instance;
  final authService = ref.watch(authServiceProvider);

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? profileSubscription;
  final authSubscription = authService.authStateChanges.listen((authUser) {
    profileSubscription?.cancel();

    if (authUser == null) {
      controller.add(null);
      return;
    }

    profileSubscription = firestore
        .collection(AppConstants.usersCollection)
        .doc(authUser.uid)
        .snapshots()
        .listen(
          (doc) {
            if (!doc.exists || doc.data() == null) {
              controller.add(null);
              return;
            }

            controller.add(UserModel.fromJson(doc.data()!));
          },
          onError: controller.addError,
        );
  }, onError: controller.addError);

  ref.onDispose(() {
    profileSubscription?.cancel();
    authSubscription.cancel();
    controller.close();
  });

  return controller.stream;
});

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
