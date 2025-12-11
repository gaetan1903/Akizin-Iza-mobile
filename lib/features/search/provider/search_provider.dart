import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/entities/user.dart';
import '../../../core/entities/public_status.dart';
import '../../../core/sources/http_client.dart';
import '../data/search_api.dart';
import '../data/search_params.dart';

/// Provider pour l'API de recherche NestJS
final Provider<SearchApi> searchApiProvider = Provider<SearchApi>(
  (Ref ref) {
    final RemoteClient remoteClient = ref.watch(remoteClientProvider);
    return SearchApi(remoteClient: remoteClient);
  },
);

/// Provider pour la recherche publique de statut relationnel
final StateNotifierProvider<PublicStatusSearchNotifier,
        AsyncValue<PublicStatus?>> publicStatusSearchProvider =
    StateNotifierProvider<PublicStatusSearchNotifier,
        AsyncValue<PublicStatus?>>(
  (Ref ref) {
    final SearchApi api = ref.watch(searchApiProvider);
    return PublicStatusSearchNotifier(api);
  },
);

/// Notifier pour la recherche publique de statut
class PublicStatusSearchNotifier
    extends StateNotifier<AsyncValue<PublicStatus?>> {
  final SearchApi _api;

  PublicStatusSearchNotifier(this._api) : super(const AsyncValue.data(null));

  /// Recherche le statut public d'un utilisateur par son code
  Future<void> search(String code) async {
    if (code.isEmpty) {
      state = const AsyncValue.data(null);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final PublicStatus status = await _api.searchPublicStatus(code);
      state = AsyncValue.data(status);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Réinitialise la recherche
  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// Provider pour la recherche par code
final StateNotifierProvider<SearchByCodeNotifier, AsyncValue<User?>>
    searchByCodeProvider =
    StateNotifierProvider<SearchByCodeNotifier, AsyncValue<User?>>(
  (Ref ref) {
    final SearchApi api = ref.watch(searchApiProvider);
    return SearchByCodeNotifier(api);
  },
);

/// Notifier pour la recherche par code
class SearchByCodeNotifier extends StateNotifier<AsyncValue<User?>> {
  final SearchApi _api;

  SearchByCodeNotifier(this._api) : super(const AsyncValue.data(null));

  /// Recherche un utilisateur par son code
  Future<void> searchByCode(String code) async {
    if (code.isEmpty) {
      state = const AsyncValue.data(null);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final User user = await _api.searchByCode(SearchByCodeParams(code: code));
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Réinitialise la recherche
  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// Provider pour la recherche par nom
final StateNotifierProvider<SearchByNameNotifier, AsyncValue<List<User>>>
    searchByNameProvider =
    StateNotifierProvider<SearchByNameNotifier, AsyncValue<List<User>>>(
  (Ref ref) {
    final SearchApi api = ref.watch(searchApiProvider);
    return SearchByNameNotifier(api);
  },
);

/// Notifier pour la recherche par nom
class SearchByNameNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final SearchApi _api;

  SearchByNameNotifier(this._api) : super(const AsyncValue.data([]));

  /// Recherche des utilisateurs par nom
  Future<void> searchByName(String name) async {
    if (name.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final List<User> users =
          await _api.searchByName(SearchByNameParams(name: name));
      state = AsyncValue.data(users);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Réinitialise la recherche
  void reset() {
    state = const AsyncValue.data([]);
  }
}
