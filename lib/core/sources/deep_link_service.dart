import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

/// Service pour gérer les deep links de l'application
/// Écoute les liens entrants (akizniz://callback?token=xxx)
class DeepLinkService {
  final AppLinks _appLinks = AppLinks();

  /// Stream controller pour diffuser les tokens reçus
  final StreamController<String> _tokenController =
      StreamController<String>.broadcast();

  /// Stream des tokens reçus via deep linking
  Stream<String> get tokenStream => _tokenController.stream;

  /// Souscription aux liens entrants
  StreamSubscription<Uri>? _linkSubscription;

  /// Initialise le service et commence à écouter les deep links
  Future<void> initialize() async {
    try {
      // Vérifie s'il y a un lien initial (app lancée via deep link)
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }

      // Écoute les nouveaux liens quand l'app est déjà ouverte
      _linkSubscription = _appLinks.uriLinkStream.listen(
        _handleDeepLink,
        onError: (Object error) {
          debugPrint('Erreur deep link: $error');
        },
      );

      debugPrint('DeepLinkService initialisé');
    } catch (e) {
      debugPrint('Erreur initialisation DeepLinkService: $e');
    }
  }

  /// Traite un deep link reçu
  void _handleDeepLink(Uri uri) {
    debugPrint('Deep link reçu: $uri');

    // Vérifie le scheme et le host
    if (uri.scheme == 'akizniz' && uri.host == 'callback') {
      // Extrait le token depuis les query parameters
      final String? token = uri.queryParameters['token'];

      if (token != null && token.isNotEmpty) {
        debugPrint('Token extrait du deep link: ${token.substring(0, 10)}...');
        _tokenController.add(token);
      } else {
        debugPrint('Deep link reçu sans token');
      }
    } else {
      debugPrint('Deep link ignoré (scheme ou host incorrect): $uri');
    }
  }

  /// Ferme le service et libère les ressources
  void dispose() {
    _linkSubscription?.cancel();
    _tokenController.close();
    debugPrint('DeepLinkService disposé');
  }
}
