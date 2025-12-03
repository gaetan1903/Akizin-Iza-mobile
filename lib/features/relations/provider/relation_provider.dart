import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/entities/relation.dart';
import '../../../core/sources/http_client.dart';
import '../data/relation_api.dart';
import '../data/relation_params.dart';

/// Provider pour l'API des relations
final Provider<RelationApi> relationApiProvider = Provider<RelationApi>(
  (Ref ref) {
    final RemoteClient remoteClient = ref.watch(remoteClientProvider);
    return RelationApi(remoteClient: remoteClient);
  },
);

/// Provider pour la liste des relations
final StateNotifierProvider<RelationListNotifier, AsyncValue<List<Relation>>>
    relationListProvider =
    StateNotifierProvider<RelationListNotifier, AsyncValue<List<Relation>>>(
  (Ref ref) {
    final RelationApi api = ref.watch(relationApiProvider);
    return RelationListNotifier(api);
  },
);

/// Notifier pour la liste des relations
class RelationListNotifier extends StateNotifier<AsyncValue<List<Relation>>> {
  final RelationApi _api;

  RelationListNotifier(this._api) : super(const AsyncValue.loading()) {
    fetchRelations();
  }

  /// Récupère la liste des relations
  Future<void> fetchRelations() async {
    state = const AsyncValue.loading();
    try {
      final List<Relation> relations = await _api.getRelations();
      state = AsyncValue.data(relations);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Crée une nouvelle relation
  Future<void> createRelation(CreateRelationParams params) async {
    try {
      await _api.createRelation(params);
      await fetchRelations();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Supprime une relation
  Future<void> deleteRelation(String relationId) async {
    try {
      await _api.deleteRelation(relationId);
      await fetchRelations();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider pour les demandes de relation en attente
final StateNotifierProvider<PendingRequestsNotifier, AsyncValue<List<Relation>>>
    pendingRequestsProvider = StateNotifierProvider<PendingRequestsNotifier,
        AsyncValue<List<Relation>>>(
  (Ref ref) {
    final RelationApi api = ref.watch(relationApiProvider);
    return PendingRequestsNotifier(api);
  },
);

/// Notifier pour les demandes en attente
class PendingRequestsNotifier extends StateNotifier<AsyncValue<List<Relation>>> {
  final RelationApi _api;

  PendingRequestsNotifier(this._api) : super(const AsyncValue.loading()) {
    fetchPendingRequests();
  }

  /// Récupère les demandes en attente
  Future<void> fetchPendingRequests() async {
    state = const AsyncValue.loading();
    try {
      final List<Relation> requests = await _api.getPendingRequests();
      state = AsyncValue.data(requests);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Répond à une demande de relation
  Future<void> respondToRequest(RespondToRelationParams params) async {
    try {
      await _api.respondToRelation(params);
      await fetchPendingRequests();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
