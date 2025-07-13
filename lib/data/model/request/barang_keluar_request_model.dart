import 'dart:convert';
import 'dart:io';
import 'package:gudapp/services/service_http_client.dart';
import 'package:http/http.dart' as http;

class BarangKeluarRequestModel {
  final int? itemId;
  final int? gudangId;
  final int? quantity;
  final String? tanggalKeluar;
  final String? keterangan;
  final String? fotoPath;
  final int? totalharga;
  final int? createdBy;

  BarangKeluarRequestModel({
    this.itemId,
    this.gudangId,
    this.quantity,
    this.tanggalKeluar,
    this.keterangan,
    this.fotoPath,
    this.totalharga,
    this.createdBy,
  });

  factory BarangKeluarRequestModel.fromJson(String str) =>
      BarangKeluarRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BarangKeluarRequestModel.fromMap(Map<String, dynamic> json) =>
      BarangKeluarRequestModel(
        itemId: json["item_id"] as int?,
        gudangId: json["gudang_id"] as int?,
        quantity: json["quantity"] as int?,
        tanggalKeluar: json["tanggal_keluar"] as String?,
        keterangan: json["keterangan"] as String?,
        fotoPath: json["foto"] as String?, // optional
        totalharga: json["total_harga_barang_keluar"] as int?,
        createdBy: json["created_by"] as int?,
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (itemId != null) map["item_id"] = itemId;
    if (gudangId != null) map["gudang_id"] = gudangId;
    if (quantity != null) map["quantity"] = quantity;
    if (tanggalKeluar != null) map["tanggal_keluar"] = tanggalKeluar;
    if (keterangan != null) map["keterangan"] = keterangan;
    if (totalharga != null) map["total_harga_barang_keluar"] = totalharga;
    if (createdBy != null) map["created_by"] = createdBy;
    return map;
  }

  BarangKeluarRequestModel copyWith({
    int? itemId,
    int? gudangId,
    int? quantity,
    String? tanggalKeluar,
    String? keterangan,
    String? fotoPath,
    int? totalharga,
    int? createdBy,
  }) {
    return BarangKeluarRequestModel(
      itemId: itemId ?? this.itemId,
      gudangId: gudangId ?? this.gudangId,
      quantity: quantity ?? this.quantity,
      tanggalKeluar: tanggalKeluar ?? this.tanggalKeluar,
      keterangan: keterangan ?? this.keterangan,
      fotoPath: fotoPath ?? this.fotoPath,
      totalharga: totalharga ?? this.totalharga,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  // Kirim data ini ke backend sebagai multipart (termasuk file)
  Future<http.Response> sendToServer() async {
    final Map<String, String> fields = {
      'item_id': itemId.toString(),
      'gudang_id': gudangId.toString(),
      'quantity': quantity.toString(),
      'tanggal_keluar': tanggalKeluar ?? '',
      'keterangan': keterangan ?? '',
      'total_harga_barang_keluar': totalharga?.toString() ?? '',
      'created_by': createdBy?.toString() ?? '1',
    };

    final client = ServiceHttpClient();
    final streamedResponse = await client.postMultipartWithToken(
      endPoint: 'barang_keluar',
      fields: fields,
      file: fotoPath != null ? File(fotoPath!) : null,
    );

    return http.Response.fromStream(streamedResponse);
  }
}
