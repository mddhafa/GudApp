import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gudapp/data/model/request/auth/login_request_model.dart';
import 'package:gudapp/data/model/request/auth/register_request_model.dart';
import 'package:gudapp/data/model/response/auth_response_model.dart';
import 'package:gudapp/services/service_http_client.dart';
import 'dart:developer';


class AuthRepository {
  final ServiceHttpClient _serviceHttpClient;
  final secureStorage = FlutterSecureStorage();

  AuthRepository(this._serviceHttpClient);

  Future<Either<String, AuthResponseModel>> login(
    LoginRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.post(
        "login",
        requestModel.toMap(),
      );
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final loginResponse = AuthResponseModel.fromMap(jsonResponse);
        await secureStorage.write(
          key: "authToken",
          value: loginResponse.user!.token,
        );
        await secureStorage.write(
          key: "userRole",
          value: loginResponse.user!.role,
        );
        log("Login successful: ${loginResponse.message}");
        log("Logged in as role: ${loginResponse.user!.role}");
        return Right(loginResponse);
      } else {
        log("Login failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Login failed");
      }
    } catch (e) {
      log("Error in login: $e");
      return Left("An error occurred while logging in.");
    }
  }

  Future<Either<String, AuthResponseModel>> register(
    RegisterRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.post(
        'register',
        requestModel.toMap(),
      );
      
      log("Status Code: ${response.statusCode}");
      log("Response Body: ${response.body}");
    

      if (response.body.isEmpty) {
        return Left('Server mengembalikan body kosong');
      }

      final jsonResponse = json.decode(response.body);


      if (response.statusCode == 201) {
        final registerResponse = AuthResponseModel.fromMap(jsonResponse);
        return Right(registerResponse);
      } else {
        return Left(jsonResponse['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat registrasi: $e');
    }
  }
}