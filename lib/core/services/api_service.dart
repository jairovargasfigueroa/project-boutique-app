// lib/core/services/api_service.dart

import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  late final Dio _dio;
  final StorageService _storage = StorageService();

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Interceptor para agregar token automáticamente a todas las peticiones
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Obtener token del storage
          final token = await _storage.getToken();

          // Si hay token, agregarlo al header
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          // Manejo de errores global
          if (error.response?.statusCode == 401) {
            // Token inválido o expirado → Limpiar storage
            await _storage.clear();
          }

          return handler.next(error);
        },
      ),
    );

    // Interceptor para logs (solo en desarrollo)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) {
          // Imprimir en consola
          print(obj);
        },
      ),
    );
  }

  // GET
  Future<Response> get(String endpoint) async {
    return await _dio.get(endpoint);
  }

  // POST
  Future<Response> post(String endpoint, dynamic data) async {
    return await _dio.post(endpoint, data: data);
  }

  // PUT
  Future<Response> put(String endpoint, dynamic data) async {
    return await _dio.put(endpoint, data: data);
  }

  // DELETE
  Future<Response> delete(String endpoint) async {
    return await _dio.delete(endpoint);
  }

  // PATCH
  Future<Response> patch(String endpoint, dynamic data) async {
    return await _dio.patch(endpoint, data: data);
  }
}
