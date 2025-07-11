import 'dart:convert';
// import 'dart:io';

import 'package:gudapp/data/model/response/gudang_response_model.dart';
import 'package:gudapp/services/service_http_client.dart';
import 'package:dartz/dartz.dart';

class GudangRepository {
  final ServiceHttpClient _serviceHttpClient;

  GudangRepository(this._serviceHttpClient);

  Future<Either<String, Gudang>> getGudangList() async {
    try {
      final response = await _serviceHttpClient.getWithToken('gudang');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final gudangResponse = Gudang.fromMap(jsonResponse);
        return Right(gudangResponse);
      } else {
        return Left(
          'Tidak ada gudang yang ditemukan. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return Left('Error fetching gudang list: $e');
    }
  }

  Future<Map<String, dynamic>> createGudang(
    Map<String, dynamic> gudangData,
  ) async {
    try {
      final response = await _serviceHttpClient.postWithToken(
        "admin/gudang",
        gudangData,
      );
      if (response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return decoded['data'];
      } else {
        throw Exception('Failed to create gudang');
      }
    } catch (e) {
      throw Exception('Error creating gudang: $e');
    }
  }

  Future<Map<String, dynamic>> updateGudang(
    int id,
    Map<String, dynamic> gudangData,
  ) async {
    try {
      final response = await _serviceHttpClient.put(
        "admin/gudang/$id",
        gudangData,
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded['data'];
      } else {
        throw Exception('Failed to update gudang');
      }
    } catch (e) {
      throw Exception('Error updating gudang: $e');
    }
  }

  Future<void> deleteGudang(int id) async {
    try {
      final response = await _serviceHttpClient.deleteWithToken(
        "admin/gudang/$id",
      );
      print('Delete status: ${response.statusCode}');
      print('Delete response: ${response.body}');
      print('Menghapus gudang ID: $id');
      print('URL: ${_serviceHttpClient.baseUrl}admin/gudang/$id');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete gudang');
      }
    } catch (e) {
      throw Exception('Error deleting gudang: $e');
    }
  }
}
