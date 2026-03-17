import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import 'secure_token_store.dart';

class AuthSessionSync {
  AuthSessionSync({
    required FirebaseAuth auth,
    required SecureTokenStore tokenStore,
    required AppUserRole Function() roleResolver,
  })  : _auth = auth,
        _tokenStore = tokenStore,
        _roleResolver = roleResolver;

  final FirebaseAuth _auth;
  final SecureTokenStore _tokenStore;
  final AppUserRole Function() _roleResolver;

  StreamSubscription<User?>? _subscription;

  void initialize() {
    _subscription ??= _auth.idTokenChanges().listen((user) async {
      if (user == null) {
        await _tokenStore.clearSession();
        return;
      }

      final idToken = await user.getIdToken();
      if (idToken == null || idToken.isEmpty) {
        await _tokenStore.clearSession();
        return;
      }

      await _tokenStore.writeSession(
        userId: user.uid,
        idToken: idToken,
        refreshToken: user.refreshToken,
        role: _roleResolver().name,
      );
    });
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
