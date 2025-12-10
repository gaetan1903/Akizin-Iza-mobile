import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/api_config.dart';
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

      final AuthResponse authResponse =
          AuthResponse.fromJson(response['data'] as Map<String, dynamic>);

      // Sauvegarde du token
      await secureStorage.saveToken(authResponse.accessToken);

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

      final AuthResponse authResponse =
          AuthResponse.fromJson(response['data'] as Map<String, dynamic>);

      // Sauvegarde du token
      await secureStorage.saveToken(authResponse.accessToken);

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
      throw BusinessException(
          'Erreur lors de la récupération de l\'utilisateur: $e');
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

  /// Obtient l'URL de base de l'API sans le trailing slash
  String get _baseUrl {
    final String url = ApiConfig.baseUrl;
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  /// Lance l'authentification Google dans le navigateur système
  /// L'utilisateur sera redirigé vers l'API qui ouvrira Google OAuth
  /// Après authentification, l'API redirigera vers akizniz://callback?token=JWT
  Future<void> signInWithGoogle() async {
    try {
      // URL complète vers l'endpoint Google OAuth de ton API
      final String googleAuthUrl = '$_baseUrl/auth/google';
      final Uri uri = Uri.parse(googleAuthUrl);

      // Vérifie si l'URL peut être lancée
      final bool canLaunch = await canLaunchUrl(uri);

      if (!canLaunch) {
        throw BusinessException(
          'Impossible d\'ouvrir le navigateur pour l\'authentification Google',
        );
      }

      // Lance l'URL dans le navigateur système
      // mode: LaunchMode.externalApplication force l'ouverture dans le navigateur
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw BusinessException(
          'Échec de l\'ouverture du navigateur',
        );
      }
      // 3. L'API redirige vers akizniz://callback?token=JWT
      // 4. DeepLinkService intercepte le lien et extrait le token
      // 5. AuthProvider traite le token via loginWithGoogleToken()
    } on BusinessException {
      rethrow;
    } catch (e) {
      throw BusinessException(
        'Erreur lors du lancement de l\'authentification Google: $e',
      );
    }
  }

  /// Sauvegarde le token reçu via deep linking et récupère l'utilisateur
  Future<User> loginWithGoogleToken(String token) async {
    try {
      // Sauvegarde le token
      await secureStorage.saveToken(token);

      // Récupère les informations de l'utilisateur avec ce token
      return await getCurrentUser();
    } catch (e) {
      // En cas d'erreur, supprime le token invalide
      await secureStorage.deleteToken();
      throw BusinessException(
        'Token invalide ou expiré: $e',
      );
    }
  }
}
