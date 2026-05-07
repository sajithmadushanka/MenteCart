import 'auth_user_model.dart';
import 'token_model.dart';

class AuthResponseModel {
  final AuthUserModel user;

  final TokenModel tokens;

  AuthResponseModel({required this.user, required this.tokens});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return AuthResponseModel(
      user: AuthUserModel.fromJson(data['user']),

      tokens: TokenModel.fromJson(data['tokens']),
    );
  }
}
