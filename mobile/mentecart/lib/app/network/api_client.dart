import 'package:dio/dio.dart';
import 'package:mentecart/app/utils/global_snackbar.dart';

import 'api_exception.dart';
import 'dio_provider.dart';

class ApiClient {
  final Dio _dio = DioProvider.createDio();

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) async {
    try {
      return await _dio.post<T>(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> patch<T>(String path, {dynamic data}) async {
    try {
      return await _dio.patch<T>(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> delete<T>(String path) async {
    try {
      return await _dio.delete<T>(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      GlobalSnackbar.show('No internet connection');

      return ApiException(message: 'No internet connection');
    }

    if (e.type == DioExceptionType.receiveTimeout) {
      return ApiException(message: 'Request timeout');
    }

    final data = e.response?.data;

    final message = data?['message'] ?? 'Something went wrong';

    return ApiException(message: message, statusCode: e.response?.statusCode);
  }
}
