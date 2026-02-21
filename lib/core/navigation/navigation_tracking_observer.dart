import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants/app_constants.dart';
import '../services/firebase_service.dart';

enum NavigationEventType { push, pop, replace }

class NavigationTrackingObserver extends NavigatorObserver {
  NavigationTrackingObserver({
    required NavigationTrackingService trackingService,
  }) : _trackingService = trackingService;

  final NavigationTrackingService _trackingService;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _trackingService.track(
      eventType: NavigationEventType.push,
      route: route,
      previousRoute: previousRoute,
    );
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _trackingService.track(
      eventType: NavigationEventType.pop,
      route: route,
      previousRoute: previousRoute,
    );
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _trackingService.track(
        eventType: NavigationEventType.replace,
        route: newRoute,
        previousRoute: oldRoute,
      );
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

class NavigationTrackingService {
  NavigationTrackingService({
    required FirebaseService firebaseService,
    required Box<dynamic> settingsBox,
  })  : _firebaseService = firebaseService,
        _settingsBox = settingsBox {
    _hydrateQueue();
  }

  static const Duration _flushInterval = Duration(seconds: 10);
  static const int _maxBatchSize = 10;

  final FirebaseService _firebaseService;
  final Box<dynamic> _settingsBox;

  final List<Map<String, dynamic>> _pendingEvents = <Map<String, dynamic>>[];
  Timer? _flushTimer;
  bool _isFlushing = false;

  void updateConsent(bool consentGranted) {
    _settingsBox.put(AppConstants.navigationTrackingConsentKey, consentGranted);

    if (!consentGranted) {
      _pendingEvents.clear();
      _persistQueue();
      _flushTimer?.cancel();
      _flushTimer = null;
      return;
    }

    _flushIfNeeded(force: true);
  }

  bool get isTrackingAllowed =>
      _settingsBox.get(AppConstants.navigationTrackingConsentKey,
          defaultValue: false) as bool;

  void track({
    required NavigationEventType eventType,
    required Route<dynamic> route,
    Route<dynamic>? previousRoute,
    Map<String, dynamic>? params,
  }) {
    if (!isTrackingAllowed) {
      return;
    }

    final user = _firebaseService.currentUser;
    final routeName = _routeName(route);

    final event = <String, dynamic>{
      'userId': user?.uid ?? 'anonymous',
      'routeName': routeName,
      'timestamp': Timestamp.now(),
      'eventType': eventType.name,
      'previousRoute': _routeName(previousRoute),
      if (params != null && params.isNotEmpty) 'params': params,
    };

    _pendingEvents.add(event);
    _persistQueue();
    _scheduleFlush();
    _flushIfNeeded();
  }

  void dispose() {
    _flushTimer?.cancel();
  }

  Future<void> flushNow() async {
    await _flushIfNeeded(force: true);
  }

  Future<void> _flushIfNeeded({bool force = false}) async {
    if (!isTrackingAllowed || _isFlushing || _pendingEvents.isEmpty) {
      return;
    }

    if (!force && _pendingEvents.length < _maxBatchSize) {
      return;
    }

    _isFlushing = true;

    try {
      while (_pendingEvents.isNotEmpty) {
        final batch = _firebaseService.firestore.batch();
        final chunk = _pendingEvents.take(_maxBatchSize).toList();

        for (final event in chunk) {
          final docRef = _firebaseService.firestore
              .collection(AppConstants.navigationEventsCollection)
              .doc();
          batch.set(docRef, event);
        }

        await batch.commit();
        _pendingEvents.removeRange(0, chunk.length);
        _persistQueue();

        if (!force) {
          break;
        }
      }
    } catch (_) {
      // Keep events in local queue, Firestore persistence + local Hive queue
      // provide offline-safe retry behavior.
    } finally {
      _isFlushing = false;
    }
  }

  void _scheduleFlush() {
    _flushTimer ??= Timer.periodic(_flushInterval, (_) {
      _flushIfNeeded(force: true);
    });
  }

  void _hydrateQueue() {
    final saved = _settingsBox.get(AppConstants.navigationEventsQueueKey,
        defaultValue: const <dynamic>[]);

    if (saved is! List<dynamic>) {
      return;
    }

    _pendingEvents
      ..clear()
      ..addAll(
        saved.whereType<Map>().map(
          (entry) => Map<String, dynamic>.from(entry),
        ),
      );
  }

  void _persistQueue() {
    _settingsBox.put(
      AppConstants.navigationEventsQueueKey,
      _pendingEvents,
    );
  }

  String _routeName(Route<dynamic>? route) {
    if (route == null) {
      return 'unknown';
    }

    final name = route.settings.name;
    if (name != null && name.isNotEmpty) {
      return name;
    }

    return route.settings.arguments?.toString() ?? route.runtimeType.toString();
  }
}
