import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration de l'API NestJS
class ApiConfig {
  /// URL de base de l'API NestJS (depuis .env)
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api/';

  /// Timeout pour les requêtes HTTP (en secondes)
  static int get connectTimeout =>
      int.tryParse(dotenv.env['API_CONNECT_TIMEOUT'] ?? '30') ?? 30;

  static int get receiveTimeout =>
      int.tryParse(dotenv.env['API_RECEIVE_TIMEOUT'] ?? '30') ?? 30;

  /// Headers par défaut
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
