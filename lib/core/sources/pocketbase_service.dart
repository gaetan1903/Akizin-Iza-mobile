import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import '../config/app_config.dart';

/// Service singleton pour gérer PocketBase
class PocketBaseService {
  static PocketBaseService? _instance;
  late final PocketBase _pb;

  PocketBaseService._() {
    _pb = PocketBase(AppConfig.pocketbaseUrl);
  }

  static PocketBaseService getInstance() {
    _instance ??= PocketBaseService._();
    return _instance!;
  }

  PocketBase get client => _pb;

  /// Authentifie un utilisateur
  Future<void> authenticate(String email, String password) async {
    await _pb.collection('users').authWithPassword(email, password);
  }

  /// Déconnecte l'utilisateur
  void logout() {
    _pb.authStore.clear();
  }

  /// Vérifie si l'utilisateur est authentifié
  bool get isAuthenticated => _pb.authStore.isValid;

  /// Récupère le token actuel
  String? get token => _pb.authStore.token;

  /// Récupère l'utilisateur connecté
  RecordModel? get currentUser => _pb.authStore.record;
}

/// Provider pour le service PocketBase
final Provider<PocketBaseService> pocketBaseServiceProvider =
    Provider<PocketBaseService>(
  (Ref ref) {
    return PocketBaseService.getInstance();
  },
);

/// Provider pour le client PocketBase
final Provider<PocketBase> pocketBaseProvider = Provider<PocketBase>(
  (Ref ref) {
    return ref.watch(pocketBaseServiceProvider).client;
  },
);
