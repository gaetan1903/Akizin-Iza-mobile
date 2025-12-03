import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/entities/wallet.dart';
import '../../../core/sources/http_client.dart';
import '../data/wallet_api.dart';

/// Provider pour l'API du wallet
final Provider<WalletApi> walletApiProvider = Provider<WalletApi>(
  (Ref ref) {
    final RemoteClient remoteClient = ref.watch(remoteClientProvider);
    return WalletApi(remoteClient: remoteClient);
  },
);

/// Provider pour le portefeuille
final StateNotifierProvider<WalletNotifier, AsyncValue<Wallet?>> walletProvider =
    StateNotifierProvider<WalletNotifier, AsyncValue<Wallet?>>(
  (Ref ref) {
    final WalletApi api = ref.watch(walletApiProvider);
    return WalletNotifier(api);
  },
);

/// Notifier pour le portefeuille
class WalletNotifier extends StateNotifier<AsyncValue<Wallet?>> {
  final WalletApi _api;

  WalletNotifier(this._api) : super(const AsyncValue.loading()) {
    fetchWallet();
  }

  /// Récupère le portefeuille
  Future<void> fetchWallet() async {
    state = const AsyncValue.loading();
    try {
      final Wallet wallet = await _api.getWallet();
      state = AsyncValue.data(wallet);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Transfère des points
  Future<void> transferPoints({
    required String recipientId,
    required int amount,
    String? message,
  }) async {
    state = const AsyncValue.loading();
    try {
      final Wallet wallet = await _api.transferPoints(
        recipientId: recipientId,
        amount: amount,
        message: message,
      );
      state = AsyncValue.data(wallet);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider pour l'historique des transactions
final StateNotifierProvider<TransactionHistoryNotifier,
        AsyncValue<List<PointTransaction>>> transactionHistoryProvider =
    StateNotifierProvider<TransactionHistoryNotifier,
        AsyncValue<List<PointTransaction>>>(
  (Ref ref) {
    final WalletApi api = ref.watch(walletApiProvider);
    return TransactionHistoryNotifier(api);
  },
);

/// Notifier pour l'historique des transactions
class TransactionHistoryNotifier
    extends StateNotifier<AsyncValue<List<PointTransaction>>> {
  final WalletApi _api;

  TransactionHistoryNotifier(this._api) : super(const AsyncValue.loading()) {
    fetchTransactions();
  }

  /// Récupère l'historique des transactions
  Future<void> fetchTransactions() async {
    state = const AsyncValue.loading();
    try {
      final List<PointTransaction> transactions = await _api.getTransactions();
      state = AsyncValue.data(transactions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
