import 'package:dio/dio.dart';
import 'package:mentecart/app/utils/global_snackbar.dart';
import 'package:mentecart/core/widgets/app_snackbar.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';

import '../services/secure_storage_service.dart';

import 'api_client.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService secureStorageService;

  final Dio dio;

  bool _isRefreshing = false;

  AuthInterceptor({required this.secureStorageService, required this.dio});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorageService.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          if (e.type == DioExceptionType.connectionError ||
              e.type == DioExceptionType.connectionTimeout) {
            if (e.type == DioExceptionType.connectionError ||
                e.type == DioExceptionType.connectionTimeout) {
              GlobalSnackbar.show('No internet connection');
            }
          }

          return handler.next(e);
        },
      ),
    );
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      return handler.next(err);
    }

    _isRefreshing = true;

    try {
      final refreshToken = await secureStorageService.getRefreshToken();

      if (refreshToken == null) {
        await secureStorageService.clearTokens();

        return handler.next(err);
      }

      final authRepository = AuthRepositoryImpl(
        remoteDatasource: AuthRemoteDatasource(apiClient: ApiClient()),
      );

      final response = await authRepository.refreshToken(refreshToken);

      await secureStorageService.saveAccessToken(response.tokens.accessToken);

      await secureStorageService.saveRefreshToken(response.tokens.refreshToken);

      final clonedRequest = await dio.request(
        err.requestOptions.path,

        data: err.requestOptions.data,

        queryParameters: err.requestOptions.queryParameters,

        options: Options(
          method: err.requestOptions.method,

          headers: {
            ...err.requestOptions.headers,

            'Authorization': 'Bearer ${response.tokens.accessToken}',
          },
        ),
      );

      return handler.resolve(clonedRequest);
    } catch (_) {
      await secureStorageService.clearTokens();

      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }
}
