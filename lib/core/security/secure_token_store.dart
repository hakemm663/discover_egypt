import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStore {
  const SecureTokenStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _idTokenKey = 'discover_egypt.id_token';
  static const _refreshTokenKey = 'discover_egypt.refresh_token';
  static const _userIdKey = 'discover_egypt.user_id';
  static const _roleKey = 'discover_egypt.user_role';

  final FlutterSecureStorage _storage;

  Future<void> writeSession({
    required String userId,
    required String idToken,
    String? refreshToken,
    String? role,
  }) async {
    await _storage.write(key: _userIdKey, value: userId);
    await _storage.write(key: _idTokenKey, value: idToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
    if (role != null && role.isNotEmpty) {
      await _storage.write(key: _roleKey, value: role);
    }
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _idTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _roleKey);
  }
}
