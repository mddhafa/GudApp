import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ServiceHttpClient {
  final String baseUrl = 'http://10.0.2.2:8000/api/';
  final secureStorage = FlutterSecureStorage();

  //post
  Future<http.Response> post(String endPoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endPoint');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  //post with token
  Future<http.Response> postWithToken(
    String endPoint,
    Map<String, dynamic> body,
  ) async {
    final token = await secureStorage.read(key: 'authToken');
    final url = Uri.parse('$baseUrl$endPoint');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to post data with token: $e');
    }
  }

  //put
  Future<http.Response> put(String endPoint, Map<String, dynamic> body) async {
    final token = await secureStorage.read(key: 'authToken');
    final url = Uri.parse('$baseUrl$endPoint');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to put data: $e');
    }
  }

  //get
  Future<http.Response> get(String endPoint) async {
    final token = await secureStorage.read(key: 'authToken');
    final url = Uri.parse('$baseUrl$endPoint');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authoritation': 'Bearer $token',
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<http.Response> getWithToken(String endPoint) async {
    final token = await secureStorage.read(key: 'authToken');
    return http.get(
      Uri.parse('$baseUrl$endPoint'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  //delete
  Future<http.Response> delete(String endPoint) async {
    final url = Uri.parse('$baseUrl$endPoint');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }

  Future<http.Response> deleteWithToken(String endPoint) async {
    final token = await secureStorage.read(key: 'authToken');
    final url = Uri.parse('$baseUrl$endPoint');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to delete data with token: $e');
    }
  }

  //post multipart
  Future<http.StreamedResponse> postMultipartWithToken({
    required String endPoint,
    required Map<String, String> fields,
    File? file,
  }) async {
    final token = await secureStorage.read(key: 'authToken');
    final uri = Uri.parse('$baseUrl$endPoint');

    var request =
        http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..headers['Accept'] = 'application/json'
          ..fields.addAll(fields);

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('foto', file.path));
    }

    return request.send();
  }


}
