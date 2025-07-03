import 'dart:convert';

class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  factory RegisterRequestModel.fromJson(String str) =>
      RegisterRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterRequestModel.fromMap(Map<String, dynamic> json) =>
      RegisterRequestModel(
        name: json["name"],
        email: json["email"],
        password: json["password"],
        confirmPassword: json["confirm_password"],
      );

  Map<String, dynamic> toMap() => {
    "name": name,
    "email": email,
    "password": password,
    "password_confirmation": confirmPassword, // <--- ini penting
  };
}