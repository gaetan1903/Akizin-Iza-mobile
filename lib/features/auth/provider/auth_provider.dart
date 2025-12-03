import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/entities/user.dart';
import '../../../core/sources/http_client.dart';
import '../../../core/sources/secure_storage_service.dart';
import '../data/auth_api.dart';
import '../data/auth_params.dart';

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
    return AuthNotifier(api);
  },
);

/// Notifier pour gérer l'état d'authentification
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthApi _api;

  AuthNotifier(this._api) : super(const AsyncValue.data(null)) {
    _checkAuthStatus();
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
