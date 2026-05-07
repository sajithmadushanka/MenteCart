import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String getMessage(
    Object error,
  ) {
    if (error is DioException) {
      final data =
          error.response?.data;

      if (data is Map &&
          data['message'] !=
              null) {
        return data['message']
            .toString();
      }

      if (error.type ==
          DioExceptionType
              .connectionTimeout) {
        return 'Connection timeout';
      }

      if (error.type ==
          DioExceptionType
              .receiveTimeout) {
        return 'Server timeout';
      }

      if (error.type ==
          DioExceptionType
              .connectionError) {
        return 'No internet connection';
      }

      return 'Something went wrong';
    }

    return error.toString();
  }
}