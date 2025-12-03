/// Configuration de l'application
class AppConfig {
  // URL de l'API PocketBase
  // En développement local
  static const String pocketbaseUrl = 'http://127.0.0.1:8090';

  // En production, remplacer par:
  // static const String pocketbaseUrl = 'https://votre-domaine.com';

  // Timeout pour les requêtes HTTP
  static const Duration requestTimeout = Duration(seconds: 30);

  // Nom de l'application
  static const String appName = 'Akizin Iza';

  // Version de l'API
  static const String apiVersion = 'v1';
}
