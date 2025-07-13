import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gudapp/data/model/response/barang_keluar_respone_model.dart';
import 'package:gudapp/services/service_http_client.dart';
import 'package:http/http.dart' as http;

class BarangKeluarRepository {
  final ServiceHttpClient _serviceHttpClient;

  BarangKeluarRepository(this._serviceHttpClient);

  Future<Either<String, BarangKeluarResponse>> getBarangKeluar() async {
    try {
      final response = await _serviceHttpClient.getWithToken('barangkeluar');

      print('[DEBUG] Status Code: ${response.statusCode}');
      print('[DEBUG] Body: ${response.body}'); // Tambahkan ini
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final barangKeluarResponse = BarangKeluarResponse.fromMap(jsonResponse);
        return Right(barangKeluarResponse);
      } else {
        return Left(
          'Tidak ada data barang keluar yang ditemukan. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return Left('Error fetching barang masuk data: $e');
    }
  }

  Future<Map<String, dynamic>> createBarangKeluar({
    required Map<String, String> fields,
    File? fotoFile,
  }) async {
    try {
      final streamedResponse = await _serviceHttpClient.postMultipartWithToken(
        endPoint: "barangkeluar",
        fields: fields,
        file: fotoFile,
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return decoded['data'];
      } else {
        throw Exception('Failed to create barang keluar');
      }
    } catch (e) {
      throw Exception('Error creating barang keluar: $e');
    }
  }

  Future<Either<String, BarangKeluarDatum>> getBarangKeluarById(int id) async {
    try {
      final response = await _serviceHttpClient.getWithToken(
        'barangkeluar/$id',
      );
      print('[DEBUG] Status Code: ${response.statusCode}');
      print('[DEBUG] Body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final barangKeluarDatum = BarangKeluarDatum.fromMap(jsonResponse);
        return Right(barangKeluarDatum);
      } else {
        return Left(
          'Tidak ada data barang keluar yang ditemukan. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return Left('Error fetching barang keluar data: $e');
    }
  }
}
