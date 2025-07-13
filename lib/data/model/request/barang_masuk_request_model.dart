import 'dart:convert';
import 'dart:io';
import 'package:gudapp/services/service_http_client.dart';
import 'package:http/http.dart' as http;

class BarangMasukRequestModel {
  final int? itemId;
  final int? gudangId;
  final int? quantity;
  final String? tanggalMasuk;
  final String? keterangan;
  final String? fotoPath; // Path lokal gambar
  final int? hargaBeli;
  final int? createdBy;

  BarangMasukRequestModel({
    this.itemId,
    this.gudangId,
    this.quantity,
    this.tanggalMasuk,
    this.keterangan,
    this.fotoPath,
    this.hargaBeli,
    this.createdBy,
  });

  factory BarangMasukRequestModel.fromJson(String str) =>
      BarangMasukRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BarangMasukRequestModel.fromMap(Map<String, dynamic> json) =>
      BarangMasukRequestModel(
        itemId: json["item_id"] as int?,
        gudangId: json["gudang_id"] as int?,
        quantity: json["quantity"] as int?,
        tanggalMasuk: json["tanggal_masuk"] as String?,
        keterangan: json["keterangan"] as String?,
        fotoPath: json["foto"] as String?, // optional
        hargaBeli: json["harga_beli"] as int?,
        createdBy: json["created_by"] as int?,
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (itemId != null) map["item_id"] = itemId;
    if (gudangId != null) map["gudang_id"] = gudangId;
    if (quantity != null) map["quantity"] = quantity;
    if (tanggalMasuk != null) map["tanggal_masuk"] = tanggalMasuk;
    if (keterangan != null) map["keterangan"] = keterangan;
    if (hargaBeli != null) map["harga_beli"] = hargaBeli;
    if (createdBy != null) map["created_by"] = createdBy;
    return map;
  }

  BarangMasukRequestModel copyWith({
    int? itemId,
    int? gudangId,
    int? quantity,
    String? tanggalMasuk,
    String? keterangan,
    String? fotoPath,
    int? hargaBeli,
    int? createdBy,
  }) {
    return BarangMasukRequestModel(
      itemId: itemId ?? this.itemId,
      gudangId: gudangId ?? this.gudangId,
      quantity: quantity ?? this.quantity,
      tanggalMasuk: tanggalMasuk ?? this.tanggalMasuk,
      keterangan: keterangan ?? this.keterangan,
      fotoPath: fotoPath ?? this.fotoPath,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  /// ✅ Kirim data ini ke backend sebagai multipart (termasuk file)
  Future<http.Response> sendToServer() async {
    final Map<String, String> fields = {
      'item_id': itemId.toString(),
      'gudang_id': gudangId.toString(),
      'quantity': quantity.toString(),
      'tanggal_masuk': tanggalMasuk ?? '',
      'keterangan': keterangan ?? '',
      'harga_beli': hargaBeli?.toString() ?? '',
      'created_by': createdBy?.toString() ?? '1',
    };

    final client = ServiceHttpClient();
    final streamedResponse = await client.postMultipartWithToken(
      endPoint: 'barang-masuk',
      fields: fields,
      file: fotoPath != null ? File(fotoPath!) : null,
    );

    return http.Response.fromStream(streamedResponse);
  }
}
