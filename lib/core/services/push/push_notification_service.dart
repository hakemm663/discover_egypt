import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

typedef ForegroundMessageHandler = FutureOr<void> Function(
  RemoteMessage message,
);
typedef OpenedMessageHandler = FutureOr<void> Function(RemoteMessage message);
typedef TokenRefreshHandler = FutureOr<void> Function(String token);

class PushNotificationService {
  PushNotificationService({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSub;
  StreamSubscription<String>? _onTokenRefreshSub;
  bool _started = false;

  Future<NotificationSettings> requestPermission() {
    return _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );
  }

  Future<String?> getToken() => _messaging.getToken();

  Future<void> start({
    required ForegroundMessageHandler onForegroundMessage,
    required OpenedMessageHandler onMessageOpenedApp,
    required TokenRefreshHandler onTokenRefresh,
  }) async {
    if (_started) return;
    _started = true;

    _onMessageSub = FirebaseMessaging.onMessage.listen(onForegroundMessage);
    _onMessageOpenedAppSub = FirebaseMessaging.onMessageOpenedApp.listen(
      onMessageOpenedApp,
    );
    _onTokenRefreshSub = _messaging.onTokenRefresh.listen(onTokenRefresh);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await onMessageOpenedApp(initialMessage);
    }
  }

  Future<void> dispose() async {
    await _onMessageSub?.cancel();
    await _onMessageOpenedAppSub?.cancel();
    await _onTokenRefreshSub?.cancel();
  }
}
