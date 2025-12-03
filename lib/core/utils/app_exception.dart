import 'package:dio/dio.dart';

/// Classe de base pour toutes les exceptions de l'application
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Exception pour les erreurs réseau
class NetworkException extends AppException {
  NetworkException([super.message = 'Erreur réseau']) : super();
}

/// Exception pour les erreurs d'authentification
class AuthException extends AppException {
  AuthException([String message = 'Erreur d\'authentification'])
      : super(message, 401);
}

/// Exception pour les erreurs métier
class BusinessException extends AppException {
  BusinessException(super.message);
}

/// Exception pour les erreurs de validation
class ValidationException extends AppException {
  ValidationException(String message) : super(message, 400);
}

/// Exception pour les ressources non trouvées
class NotFoundException extends AppException {
  NotFoundException([String message = 'Ressource non trouvée'])
      : super(message, 404);
}

/// Exception pour les erreurs serveur
class ServerException extends AppException {
  ServerException([String message = 'Erreur serveur'])
      : super(message, 500);
}

/// Gestionnaire d'erreurs pour convertir les DioException en AppException
AppException handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return NetworkException('Délai de connexion dépassé');
    
    case DioExceptionType.connectionError:
      return NetworkException('Pas de connexion Internet');
    
    case DioExceptionType.badResponse:
      final int? statusCode = error.response?.statusCode;
      final dynamic data = error.response?.data;
      
      String message = 'Une erreur est survenue';
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        message = data['message'] as String;
      }
      
      switch (statusCode) {
        case 400:
          return ValidationException(message);
        case 401:
          return AuthException(message);
        case 404:
          return NotFoundException(message);
        case 500:
        case 502:
        case 503:
          return ServerException(message);
        default:
          return BusinessException(message);
      }
    
    case DioExceptionType.cancel:
      return BusinessException('Requête annulée');
    
    case DioExceptionType.badCertificate:
      return NetworkException('Certificat SSL invalide');
    
    case DioExceptionType.unknown:
      return NetworkException('Erreur de connexion');
  }
}
