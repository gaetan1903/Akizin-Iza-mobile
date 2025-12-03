/// Configuration de l'API NestJS
class ApiConfig {
  /// URL de base de l'API NestJS
  /// Modifier cette valeur selon ton environnement :
  /// - Production: 'https://api.akiziniza.com/api/v1/'
  /// - Staging: 'https://staging-api.akiziniza.com/api/v1/'
  /// - Local: 'http://localhost:3000/api/v1/'
  static const String baseUrl = 'http://localhost:3000/api/v1/';

  /// Timeout pour les requêtes HTTP (en secondes)
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;

  /// Headers par défaut
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
