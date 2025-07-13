import 'dart:convert';

import 'package:gudapp/data/model/response/profile_pegawai_response_model.dart';
import 'package:gudapp/services/service_http_client.dart';

class ProfilePegawaiRepository {
  final ServiceHttpClient _serviceHttpClient;

  ProfilePegawaiRepository(this._serviceHttpClient);

  Future<ProfilePegawaiResponse> getProfile() async {
    try {
      final response = await _serviceHttpClient.getWithToken('profile');

      if (response.statusCode == 200) {
        return ProfilePegawaiResponse.fromJson(response.body);
      } else {
        throw Exception(
          'Gagal mengambil data profil pegawai: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil profil: $e');
    }
  }

  Future<Map<String, dynamic>> createProfile(
    Map<String, dynamic> itemData,
  ) async {
    try {
      final response = await _serviceHttpClient.postWithToken(
        "profile",
        itemData,
      );
      if (response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return decoded['data'];
      } else {
        throw Exception('Failed to create item');
      }
    } catch (e) {
      throw Exception('Error creating item: $e');
    }
  }
}
