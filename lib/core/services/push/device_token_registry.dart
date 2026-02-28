import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

import '../../constants/app_constants.dart';

class DeviceTokenRegistry {
  DeviceTokenRegistry({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<void> syncToken({
    required String uid,
    required String token,
    required String platform,
    required String appEnv,
    required bool notificationsEnabled,
    required String locale,
    required String appVersion,
    required String buildNumber,
  }) async {
    final now = Timestamp.now();
    final tokenHash = hashToken(token);

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection('device_tokens')
        .doc(tokenHash)
        .set({
      'token': token,
      'platform': platform,
      'appEnv': appEnv,
      'notificationsEnabled': notificationsEnabled,
      'locale': locale,
      'updatedAt': now,
      'lastSeenAt': now,
      'appVersion': appVersion,
      'buildNumber': buildNumber,
    }, SetOptions(merge: true));
  }

  Future<void> disableToken({
    required String uid,
    required String token,
    required String platform,
    required String appEnv,
    required String locale,
    required String appVersion,
    required String buildNumber,
  }) async {
    final now = Timestamp.now();
    final tokenHash = hashToken(token);

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection('device_tokens')
        .doc(tokenHash)
        .set({
      'token': token,
      'platform': platform,
      'appEnv': appEnv,
      'notificationsEnabled': false,
      'locale': locale,
      'updatedAt': now,
      'lastSeenAt': now,
      'appVersion': appVersion,
      'buildNumber': buildNumber,
    }, SetOptions(merge: true));
  }

  static String hashToken(String token) {
    return sha256.convert(utf8.encode(token)).toString();
  }
}
