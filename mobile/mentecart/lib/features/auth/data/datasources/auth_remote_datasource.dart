import 'package:mentecart/app/network/api_client.dart';
import 'package:mentecart/features/auth/data/models/auth_user_model.dart';

import '../models/auth_response_model.dart';

class AuthRemoteDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasource({required this.apiClient});

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    return AuthResponseModel.fromJson(response.data);
  }

  Future<AuthUserModel> getCurrentUser() async {
    final response = await apiClient.get('/auth/me');

    return AuthUserModel.fromJson(response.data['data']);
  }

  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final response = await apiClient.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );

    return AuthResponseModel.fromJson(response.data);
  }

  // sign up process ---

  Future<AuthResponseModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      '/auth/signup',
      data: {'name': name, 'email': email, 'password': password},
    );

    return AuthResponseModel.fromJson(response.data);
  }

  Future<void> logout() async {
    await apiClient.post('/auth/logout');
  }
}
