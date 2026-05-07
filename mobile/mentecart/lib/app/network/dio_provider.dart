import 'package:dio/dio.dart';
import 'package:mentecart/core/config/env.dart';

import '../services/secure_storage_service.dart';

import 'auth_interceptor.dart';

class DioProvider {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,

        connectTimeout: const Duration(seconds: 30),

        receiveTimeout: const Duration(seconds: 30),

        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(secureStorageService: SecureStorageService(), dio: dio),
    );

    return dio;
  }
}
