import 'package:mentecart/features/auth/data/models/auth_user_model.dart';

import '../../data/models/auth_response_model.dart';

abstract class AuthRepository {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });
  Future<AuthUserModel> getCurrentUser();

  Future<AuthResponseModel> refreshToken(String refreshToken);

  // sign up process ---
  Future<AuthResponseModel>
    signup({
  required String name,
  required String email,
  required String password,
});

Future<void> logout();
}
