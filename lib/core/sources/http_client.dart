import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/api_config.dart';
import '../utils/app_exception.dart';
import 'secure_storage_service.dart';

/// Client HTTP pour les appels API NestJS
class RemoteClient {
  final Dio _dio;
  final SecureStorageService _secureStorage;

  RemoteClient({
    required Dio dio,
    required SecureStorageService secureStorage,
    String? baseUrl,
  })  : _dio = dio,
        _secureStorage = secureStorage {
    _dio.options.baseUrl = baseUrl ?? ApiConfig.baseUrl;
    _dio.options.connectTimeout = Duration(seconds: ApiConfig.connectTimeout);
    _dio.options.receiveTimeout = Duration(seconds: ApiConfig.receiveTimeout);
    _dio.options.headers = ApiConfig.defaultHeaders;

    // Intercepteur pour ajouter le token d'authentification
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          final String? token = await _secureStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          return handler.next(error);
        },
      ),
    );
  }

  /// Effectue une requête GET
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  /// Effectue une requête POST
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  /// Effectue une requête PUT
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response<dynamic> response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  /// Effectue une requête DELETE
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response<dynamic> response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  /// Effectue une requête PATCH
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response<dynamic> response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw handleError(e);
    }
  }
}

/// Provider pour le client Dio
final Provider<Dio> dioProvider = Provider<Dio>((Ref ref) {
  return Dio();
});

/// Provider pour le client HTTP
final Provider<RemoteClient> remoteClientProvider = Provider<RemoteClient>(
  (Ref ref) {
    final Dio dio = ref.watch(dioProvider);
    final SecureStorageService secureStorage = ref.watch(secureStorageProvider);
    return RemoteClient(
      dio: dio,
      secureStorage: secureStorage,
    );
  },
);
