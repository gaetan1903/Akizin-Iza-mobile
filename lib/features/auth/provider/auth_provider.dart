import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/entities/user.dart';
import '../../../core/sources/deep_link_service.dart';
import '../../../core/sources/http_client.dart';
import '../../../core/sources/secure_storage_service.dart';
import '../data/auth_api.dart';
import '../data/auth_params.dart';

/// Provider pour le service de deep linking
final Provider<DeepLinkService> deepLinkServiceProvider =
    Provider<DeepLinkService>(
  (Ref ref) {
    final DeepLinkService service = DeepLinkService();
    service.initialize();

    // Cleanup lors de la destruction du provider
    ref.onDispose(() {
      service.dispose();
    });

    return service;
  },
);

/// Provider pour l'API d'authentification
final Provider<AuthApi> authApiProvider = Provider<AuthApi>(
  (Ref ref) {
    final RemoteClient remoteClient = ref.watch(remoteClientProvider);
    final SecureStorageService secureStorage = ref.watch(secureStorageProvider);
    return AuthApi(
      remoteClient: remoteClient,
      secureStorage: secureStorage,
    );
  },
);

/// Provider pour l'état d'authentification
final StateNotifierProvider<AuthNotifier, AsyncValue<User?>> authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>(
  (Ref ref) {
    final AuthApi api = ref.watch(authApiProvider);
    final DeepLinkService deepLinkService = ref.watch(deepLinkServiceProvider);
    return AuthNotifier(api, deepLinkService);
  },
);

/// Notifier pour gérer l'état d'authentification
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthApi _api;
  final DeepLinkService _deepLinkService;

  AuthNotifier(this._api, this._deepLinkService)
      : super(const AsyncValue.data(null)) {
    _checkAuthStatus();
    _listenToDeepLinks();
  }

  /// Vérifie le statut d'authentification au démarrage
  Future<void> _checkAuthStatus() async {
    try {
      final User user = await _api.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }

  /// Écoute les tokens reçus via deep linking
  void _listenToDeepLinks() {
    _deepLinkService.tokenStream.listen(
      (String token) async {
        await loginWithGoogleToken(token);
      },
      onError: (Object error) {
        state = AsyncValue.error(
          error,
          StackTrace.current,
        );
      },
    );
  }

  /// Connecte un utilisateur
  Future<void> login(LoginParams params) async {
    state = const AsyncValue.loading();
    try {
      final User user = await _api.login(params);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Inscrit un nouvel utilisateur
  Future<void> register(RegisterParams params) async {
    state = const AsyncValue.loading();
    try {
      final User user = await _api.register(params);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Vérifie le compte utilisateur
  Future<void> verify(VerificationParams params) async {
    state = const AsyncValue.loading();
    try {
      final User user = await _api.verify(params);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Déconnecte l'utilisateur
  Future<void> logout() async {
    try {
      await _api.logout();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Lance l'authentification Google via le navigateur
  /// Le token sera reçu automatiquement via deep linking
  Future<void> signInWithGoogle() async {
    try {
      state = const AsyncValue.loading();
      await _api.signInWithGoogle();
      // L'état sera mis à jour automatiquement quand le token arrivera via deep link
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Traite le token reçu via deep linking
  Future<void> loginWithGoogleToken(String token) async {
    state = const AsyncValue.loading();
    try {
      final User user = await _api.loginWithGoogleToken(token);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Connexion avec Google (via GoogleAuthService) - DEPRECATED
  /// Utiliser signInWithGoogle() à la place
  @Deprecated('Utiliser signInWithGoogle() pour deep linking')
  Future<void> loginWithGoogle(Map<String, dynamic> authData) async {
    state = const AsyncValue.loading();
    try {
      // Parse les données reçues de GoogleAuthService
      final User user = User.fromJson(authData['user'] as Map<String, dynamic>);
      final String accessToken = authData['accessToken'] as String;

      // Sauvegarde le token
      await _api.secureStorage.saveToken(accessToken);

      // Met à jour l'état avec l'utilisateur connecté
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Rafraîchit les données de l'utilisateur
  Future<void> refreshUser() async {
    try {
      final User user = await _api.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider pour vérifier si l'utilisateur est connecté
final Provider<bool> isAuthenticatedProvider = Provider<bool>(
  (Ref ref) {
    final AsyncValue<User?> authState = ref.watch(authProvider);
    return authState.maybeWhen(
      data: (User? user) => user != null,
      orElse: () => false,
    );
  },
);
