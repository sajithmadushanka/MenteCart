import 'package:mentecart/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mentecart/features/auth/data/models/auth_user_model.dart';

import '../../domain/repositories/auth_repository.dart';
import '../models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) {
    return remoteDatasource.login(email: email, password: password);
  }

  @override
  Future<AuthUserModel> getCurrentUser() {
    return remoteDatasource.getCurrentUser();
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) {
    return remoteDatasource.refreshToken(refreshToken);
  }

  @override
  Future<AuthResponseModel> signup({
    required String name,
    required String email,
    required String password,
  }) {
    return remoteDatasource.signup(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() {
    return remoteDatasource.logout();
  }
}
