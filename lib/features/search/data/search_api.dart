import 'package:dio/dio.dart';
import '../../../core/entities/user.dart';
import '../../../core/sources/http_client.dart';
import '../../../core/utils/app_exception.dart';
import 'search_params.dart';

/// API pour la recherche d'utilisateurs via NestJS
class SearchApi {
  final RemoteClient remoteClient;

  /// Crée une instance de [SearchApi] avec les dépendances nécessaires
  SearchApi({required this.remoteClient});

  /// Recherche un utilisateur par son code
  /// Lance une [AppException] en cas d'échec
  /// Équivalent TypeScript (API NestJS):
  /// ```ts
  /// async getRelationByCode(code_user: string): Promise<UserEntity> {
  ///   const result = await axios.get(`/check-relationships`, {
  ///     params: { code_user }
  ///   });
  ///   return result.data;
  /// }
  /// ```
  Future<User> searchByCode(SearchByCodeParams params) async {
    try {
      final Map<String, dynamic> response = await remoteClient.get(
        'check-relationships',
        queryParameters: {'code_user': params.code},
      );

      // L'API NestJS retourne directement les données utilisateur
      return User.fromJson(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors de la recherche par code: $e');
    }
  }

  /// Recherche des utilisateurs par nom
  Future<List<User>> searchByName(SearchByNameParams params) async {
    try {
      final Map<String, dynamic> response = await remoteClient.get(
        'users/search',
        queryParameters: {'name': params.name},
      );

      final List<dynamic> usersJson = response['data'] as List<dynamic>;
      return usersJson
          .map((dynamic json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors de la recherche par nom: $e');
    }
  }
}
