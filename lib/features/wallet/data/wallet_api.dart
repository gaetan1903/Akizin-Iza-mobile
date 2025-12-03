import 'package:dio/dio.dart';
import '../../../core/entities/wallet.dart';
import '../../../core/sources/http_client.dart';
import '../../../core/utils/app_exception.dart';

/// API pour la gestion du portefeuille de points
class WalletApi {
  final RemoteClient remoteClient;

  /// Crée une instance de [WalletApi] avec les dépendances nécessaires
  WalletApi({required this.remoteClient});

  /// Récupère le portefeuille de l'utilisateur
  /// Lance une [AppException] en cas d'échec
  Future<Wallet> getWallet() async {
    try {
      final Map<String, dynamic> response = await remoteClient.get('wallet');
      return Wallet.fromJson(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors de la récupération du portefeuille: $e');
    }
  }

  /// Récupère l'historique des transactions
  Future<List<PointTransaction>> getTransactions() async {
    try {
      final Map<String, dynamic> response = await remoteClient.get(
        'wallet/transactions',
      );
      final List<dynamic> transactionsJson = response['data'] as List<dynamic>;
      return transactionsJson
          .map((dynamic json) =>
              PointTransaction.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException(
          'Erreur lors de la récupération des transactions: $e');
    }
  }

  /// Transfère des points à un autre utilisateur
  Future<Wallet> transferPoints({
    required String recipientId,
    required int amount,
    String? message,
  }) async {
    try {
      final Map<String, dynamic> response = await remoteClient.post(
        'wallet/transfer',
        data: {
          'recipientId': recipientId,
          'amount': amount,
          if (message != null) 'message': message,
        },
      );
      return Wallet.fromJson(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw BusinessException('Erreur lors du transfert de points: $e');
    }
  }
}
