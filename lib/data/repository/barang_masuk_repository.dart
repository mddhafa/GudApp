import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gudapp/data/model/response/barang_masuk_resonse_model.dart';
import 'package:gudapp/services/service_http_client.dart';
import 'package:http/http.dart' as http;

class BarangMasukRepository {
  final ServiceHttpClient _serviceHttpClient;

  BarangMasukRepository(this._serviceHttpClient);

  Future<Either<String, BarangMasukResponse>> getBarangMasuk() async {
    try {
      final response = await _serviceHttpClient.getWithToken('barangmasuk');

      print('[DEBUG] Status Code: ${response.statusCode}');
      print('[DEBUG] Body: ${response.body}'); // Tambahkan ini
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final barangMasukResponse = BarangMasukResponse.fromMap(jsonResponse);
        return Right(barangMasukResponse);
      } else {
        return Left(
          'Tidak ada data barang masuk yang ditemukan. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return Left('Error fetching barang masuk data: $e');
    }
  }

  // Future<Either<String, BarangMasukResponse>> getBarangMasuk() async {
  //   try {
  //     final response = await _serviceHttpClient.getWithToken('barangmasuk');
  //     print('[REPO] Response status: ${response.statusCode}');
  //     print('[REPO] Response body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final data = BarangMasukResponse.fromJson(response.body);
  //       return Right(data);
  //     } else {
  //       return Left('Gagal mengambil data');
  //     }
  //   } catch (e) {
  //     print('[REPO] Exception: $e');
  //     return Left(e.toString());
  //   }
  // }

  Future<Map<String, dynamic>> createBarangMasukWithFoto({
    required Map<String, String> fields,
    File? fotoFile,
  }) async {
    try {
      final streamedResponse = await _serviceHttpClient.postMultipartWithToken(
        endPoint: "barangmasuk",
        fields: fields,
        file: fotoFile,
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return decoded['data'];
      } else {
        throw Exception('Failed to create barang masuk');
      }
    } catch (e) {
      throw Exception('Error creating barang masuk: $e');
    }
  }

  Future<Either<String, Datum>> getBarangMasukById(int id) async {
    try {
      final response = await _serviceHttpClient.getWithToken('barangmasuk/$id');

      print('URL: ${_serviceHttpClient.baseUrl}barangmasuk/$id');
      print('[DEBUG] Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final item = Datum.fromMap(jsonResponse['data']);
        return Right(item);
      } else {
        return Left('Item not found. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Error fetching item by ID: $e');
    }
  }

  Future<Map<String, dynamic>> updateBarangMasuk(
    int id,
    Map<String, dynamic> barangMasukData,
  ) async {
    try {
      final response = await _serviceHttpClient.put(
        "barangmasuk/$id",
        barangMasukData,
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded['data'];
      } else {
        throw Exception('Failed to update barang masuk');
      }
    } catch (e) {
      throw Exception('Error updating barang masuk: $e');
    }
  }

  Future<void> deleteBarangMasuk(int id) async {
    try {
      final response = await _serviceHttpClient.deleteWithToken(
        'barangmasuk/$id',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete barang masuk');
      }
    } catch (e) {
      throw Exception('Error deleting barang masuk: $e');
    }
  }
}
