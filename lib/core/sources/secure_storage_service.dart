import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service pour gérer le stockage local
class SecureStorageService {
  final SharedPreferences _prefs;

  SecureStorageService(this._prefs);

  // Clés de stockage
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  /// Sauvegarde le token d'authentification
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  /// Récupère le token d'authentification
  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  /// Supprime le token d'authentification
  Future<void> deleteToken() async {
    await _prefs.remove(_tokenKey);
  }

  /// Sauvegarde le refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  /// Récupère le refresh token
  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  /// Supprime le refresh token
  Future<void> deleteRefreshToken() async {
    await _prefs.remove(_refreshTokenKey);
  }

  /// Sauvegarde l'ID de l'utilisateur
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  /// Récupère l'ID de l'utilisateur
  Future<String?> getUserId() async {
    return _prefs.getString(_userIdKey);
  }

  /// Supprime l'ID de l'utilisateur
  Future<void> deleteUserId() async {
    await _prefs.remove(_userIdKey);
  }

  /// Sauvegarde une valeur générique
  Future<void> write(String key, String value) async {
    await _prefs.setString(key, value);
  }

  /// Récupère une valeur générique
  Future<String?> read(String key) async {
    return _prefs.getString(key);
  }

  /// Supprime une valeur générique
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  /// Supprime toutes les données
  Future<void> deleteAll() async {
    await _prefs.clear();
  }

  /// Vérifie si l'utilisateur est connecté
  Future<bool> isAuthenticated() async {
    final String? token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

/// Provider pour SharedPreferences
final Provider<SharedPreferences> sharedPreferencesProvider =
    Provider<SharedPreferences>(
  (Ref ref) {
    throw UnimplementedError(
      'sharedPreferencesProvider must be overridden in main.dart',
    );
  },
);

/// Provider pour le service de stockage
final Provider<SecureStorageService> secureStorageProvider =
    Provider<SecureStorageService>(
  (Ref ref) {
    final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);
    return SecureStorageService(prefs);
  },
);
