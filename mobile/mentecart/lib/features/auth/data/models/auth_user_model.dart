class AuthUserModel {
  final String id;

  final String name;

  final String email;

  final String role;

  AuthUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'],

      name: json['name'],

      email: json['email'],

      role: json['role'],
    );
  }
}
