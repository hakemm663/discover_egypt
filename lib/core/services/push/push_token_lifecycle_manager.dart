import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../constants/app_constants.dart';
import 'device_token_registry.dart';
import 'push_notification_service.dart';

class PushTokenLifecycleManager {
  PushTokenLifecycleManager({
    required Stream<User?> authStateChanges,
    required User? currentUser,
    required PushNotificationService pushService,
    required DeviceTokenRegistry tokenRegistry,
    required Box<dynamic> settingsBox,
  })  : _authStateChanges = authStateChanges,
        _currentUser = currentUser,
        _pushService = pushService,
        _tokenRegistry = tokenRegistry,
        _settingsBox = settingsBox;

  static const String _tokenKey = 'push.device_token';
  static const String _tokenUidKey = 'push.device_token.uid';

  final Stream<User?> _authStateChanges;
  User? _currentUser;
  final PushNotificationService _pushService;
  final DeviceTokenRegistry _tokenRegistry;
  final Box<dynamic> _settingsBox;

  StreamSubscription<User?>? _authSubscription;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await _pushService.start(
      onForegroundMessage: _onForegroundMessage,
      onMessageOpenedApp: _onMessageOpenedApp,
      onTokenRefresh: _onTokenRefresh,
    );

    final settings = await _pushService.requestPermission();
    final notificationsEnabled =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;

    final token = await _pushService.getToken();
    if (token != null && token.isNotEmpty) {
      _persistToken(token);
    }

    final activeUser = _currentUser;
    if (activeUser != null && token != null && token.isNotEmpty) {
      await _syncTokenForUser(
        uid: activeUser.uid,
        token: token,
        notificationsEnabled: notificationsEnabled,
      );
    }

    _authSubscription = _authStateChanges.listen(_handleAuthStateChange);
  }

  Future<void> dispose() async {
    await _authSubscription?.cancel();
    await _pushService.dispose();
  }

  Future<void> _handleAuthStateChange(User? nextUser) async {
    final previousUser = _currentUser;
    _currentUser = nextUser;

    if (previousUser != null && nextUser == null) {
      await _disableCurrentTokenForUser(previousUser.uid);
      _settingsBox.delete(_tokenUidKey);
      return;
    }

    if (nextUser != null) {
      final settings = await _pushService.requestPermission();
      final notificationsEnabled =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;
      final token = await _pushService.getToken();
      if (token != null && token.isNotEmpty) {
        _persistToken(token);
        await _syncTokenForUser(
          uid: nextUser.uid,
          token: token,
          notificationsEnabled: notificationsEnabled,
        );
      }
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    debugPrint('Push notification foreground message: ${message.messageId}');
  }

  Future<void> _onMessageOpenedApp(RemoteMessage message) async {
    debugPrint('Push notification opened app message: ${message.messageId}');
  }

  Future<void> _onTokenRefresh(String token) async {
    if (token.isEmpty) return;

    _persistToken(token);

    final user = _currentUser;
    if (user == null) {
      return;
    }

    final settings = await _pushService.requestPermission();
    final notificationsEnabled =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;

    await _syncTokenForUser(
      uid: user.uid,
      token: token,
      notificationsEnabled: notificationsEnabled,
    );
  }

  Future<void> _syncTokenForUser({
    required String uid,
    required String token,
    required bool notificationsEnabled,
  }) {
    _settingsBox.put(_tokenUidKey, uid);

    return _tokenRegistry.syncToken(
      uid: uid,
      token: token,
      platform: _platform,
      appEnv: _appEnv,
      notificationsEnabled: notificationsEnabled,
      locale: _locale,
      appVersion: AppConstants.appVersion,
      buildNumber: AppConstants.appBuildNumber,
    );
  }

  Future<void> _disableCurrentTokenForUser(String uid) async {
    final token = _settingsBox.get(_tokenKey) as String?;
    if (token == null || token.isEmpty) {
      return;
    }

    await _tokenRegistry.disableToken(
      uid: uid,
      token: token,
      platform: _platform,
      appEnv: _appEnv,
      locale: _locale,
      appVersion: AppConstants.appVersion,
      buildNumber: AppConstants.appBuildNumber,
    );
  }

  void _persistToken(String token) {
    _settingsBox.put(_tokenKey, token);
  }

  String get _locale {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    return locale.toLanguageTag();
  }

  String get _appEnv {
    return const String.fromEnvironment('APP_ENV', defaultValue: 'production');
  }

  String get _platform {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }
}
