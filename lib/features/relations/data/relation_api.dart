import 'package:dio/dio.dart';
import '../../../core/entities/relation.dart';
import '../../../core/sources/http_client.dart';
import '../../../core/utils/app_exception.dart';
import 'relation_params.dart';

/// API pour la gestion des relations
class RelationApi {
  final RemoteClient remoteClient;

  /// Crée une instance de [RelationApi] avec les dépendances nécessaires
  RelationApi({required this.remoteClient});

  /// Récupère la liste des relations
  /// Lance une [AppException] en cas d'échec
  Future<List<Relation>> getRelations() async {
    try {
      final Map<String, dynamic> response = await remoteClient.get('relations');
      final List<dynamic> relationsJson = response['data'] as List<dynamic>;
      return relationsJson
          .map((dynamic json) => Relation.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors de la récupération des relations: $e');
    }
  }

  /// Récupère les demandes de relation en attente
  Future<List<Relation>> getPendingRequests() async {
    try {
      final Map<String, dynamic> response = await remoteClient.get(
        'relations/pending',
      );
      final List<dynamic> relationsJson = response['data'] as List<dynamic>;
      return relationsJson
          .map((dynamic json) => Relation.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors de la récupération des demandes: $e');
    }
  }

  /// Crée une demande de relation
  Future<Relation> createRelation(CreateRelationParams params) async {
    try {
      final Map<String, dynamic> response = await remoteClient.post(
        'relations',
        data: params.toJson(),
      );
      return Relation.fromJson(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors de la création de la relation: $e');
    }
  }

  /// Accepte ou refuse une demande de relation
  Future<Relation> respondToRelation(RespondToRelationParams params) async {
    try {
      final Map<String, dynamic> response = await remoteClient.post(
        'relations/${params.relationId}/respond',
        data: {'accept': params.accept},
      );
      return Relation.fromJson(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors de la réponse à la demande: $e');
    }
  }

  /// Supprime une relation
  Future<void> deleteRelation(String relationId) async {
    try {
      await remoteClient.delete('relations/$relationId');
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors de la suppression de la relation: $e');
    }
  }

  /// Récupère une relation par son ID
  Future<Relation> getRelationById(String relationId) async {
    try {
      final Map<String, dynamic> response = await remoteClient.get(
        'relations/$relationId',
      );
      return Relation.fromJson(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors de la récupération de la relation: $e');
    }
  }
}
