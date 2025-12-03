import 'package:dio/dio.dart';
import '../../../core/entities/user.dart';
import '../../../core/sources/http_client.dart';
import '../../../core/sources/secure_storage_service.dart';
import '../../../core/utils/app_exception.dart';
import 'auth_params.dart';

/// API pour la gestion de l'authentification
class AuthApi {
  final RemoteClient remoteClient;
  final SecureStorageService secureStorage;

  /// Crée une instance de [AuthApi] avec les dépendances nécessaires
  AuthApi({
    required this.remoteClient,
    required this.secureStorage,
  });

  /// Connecte un utilisateur
  /// Lance une [AppException] en cas d'échec
  Future<User> login(LoginParams params) async {
    try {
      final Map<String, dynamic> response = await remoteClient.post(
        'auth/login',
        data: params.toJson(),
      );

      final AuthResponse authResponse = AuthResponse.fromJson(response['data'] as Map<String, dynamic>);
      
      // Sauvegarde des tokens
      await secureStorage.saveToken(authResponse.token);
      await secureStorage.saveRefreshToken(authResponse.refreshToken);

      return User.fromJson(authResponse.user);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors de la connexion: $e');
    }
  }

  /// Inscrit un nouvel utilisateur
  Future<User> register(RegisterParams params) async {
    try {
      final Map<String, dynamic> response = await remoteClient.post(
        'auth/register',
        data: params.toJson(),
      );

      final AuthResponse authResponse = AuthResponse.fromJson(response['data'] as Map<String, dynamic>);
      
      // Sauvegarde des tokens
      await secureStorage.saveToken(authResponse.token);
      await secureStorage.saveRefreshToken(authResponse.refreshToken);

      return User.fromJson(authResponse.user);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors de l\'inscription: $e');
    }
  }

  /// Vérifie le compte utilisateur
  Future<User> verify(VerificationParams params) async {
    try {
      final Map<String, dynamic> response = await remoteClient.post(
        'auth/verify',
        data: params.toJson(),
      );

      return User.fromJson(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors de la vérification: $e');
    }
  }

  /// Déconnecte l'utilisateur
  Future<void> logout() async {
    try {
      await remoteClient.post('auth/logout');
      await secureStorage.deleteAll();
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors de la déconnexion: $e');
    }
  }

  /// Récupère l'utilisateur connecté
  Future<User> getCurrentUser() async {
    try {
      final Map<String, dynamic> response = await remoteClient.get('auth/me');
      return User.fromJson(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors de la récupération de l\'utilisateur: $e');
    }
  }

  /// Rafraîchit le token d'authentification
  Future<void> refreshToken() async {
    try {
      final String? refreshToken = await secureStorage.getRefreshToken();
      if (refreshToken == null) {
        throw AuthException('Aucun refresh token disponible');
      }

      final Map<String, dynamic> response = await remoteClient.post(
        'auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final String newToken = response['data']['token'] as String;
      await secureStorage.saveToken(newToken);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors du rafraîchissement du token: $e');
    }
  }
}
