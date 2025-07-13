import 'dart:convert';

class BarangKeluarResponse {
  final String? message;
  final bool? success;
  final List<BarangKeluarDatum>? data;

  BarangKeluarResponse({this.message, this.success, this.data});

  factory BarangKeluarResponse.fromJson(String str) =>
      BarangKeluarResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BarangKeluarResponse.fromMap(Map<String, dynamic> json) =>
      BarangKeluarResponse(
        message: json["message"],
        success: json["success"],
        data:
            json["data"] == null
                ? []
                : List<BarangKeluarDatum>.from(
                  json["data"]!.map((x) => BarangKeluarDatum.fromMap(x)),
                ),
      );

  Map<String, dynamic> toMap() => {
    "message": message,
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class BarangKeluarDatum {
  final int? id;
  final int? itemId;
  final int? gudangId;
  final int? jumlah;
  final int? quantity;
  final DateTime? tanggalKeluar;
  final dynamic keterangan;
  final dynamic foto;
  final int? totalharga;
  final CreatedBy? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String? itemName;
  final String? gudangName;

  BarangKeluarDatum({
    this.id,
    this.itemId,
    this.gudangId,
    this.quantity,
    this.tanggalKeluar,
    this.keterangan,
    this.foto,
    this.totalharga,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.jumlah,

    this.itemName,
    this.gudangName,
  });

  factory BarangKeluarDatum.fromJson(String str) =>
      BarangKeluarDatum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BarangKeluarDatum.fromMap(
    Map<String, dynamic> json,
  ) => BarangKeluarDatum(
    id: json["id"],
    itemId: json["item_id"],
    gudangId: json["gudang_id"],
    quantity: json["quantity"],
    tanggalKeluar:
        json["tanggal_keluar"] == null
            ? null
            : DateTime.parse(json["tanggal_keluar"]),
    keterangan: json["keterangan"],
    foto: json["foto"],
    totalharga: json["total_harga_barang_keluar"],
    createdBy:
        json["created_by"] == null
            ? null
            : CreatedBy.fromMap(json["created_by"]),
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),

    itemName: json["item"]?["name"],
    gudangName: json["gudang"]?["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "item_id": itemId,
    "gudang_id": gudangId,
    "quantity": quantity,
    "tanggalKeluar":
        "${tanggalKeluar!.year.toString().padLeft(4, '0')}-${tanggalKeluar!.month.toString().padLeft(2, '0')}-${tanggalKeluar!.day.toString().padLeft(2, '0')}",
    "keterangan": keterangan,
    "foto": foto,
    "totalharga": totalharga,
    "created_by": createdBy?.toMap(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "item_name": itemName,
    "gudang_name": gudangName,
  };
}

class CreatedBy {
  final int? id;
  final String? name;
  final String? email;
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? roleId;

  CreatedBy({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.roleId,
  });

  factory CreatedBy.fromJson(String str) => CreatedBy.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreatedBy.fromMap(Map<String, dynamic> json) => CreatedBy(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt:
        json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    roleId: json["role_id"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "role_id": roleId,
  };
}

class Item {
  final int? id;
  final String? name;

  Item({this.id, this.name});

  factory Item.fromMap(Map<String, dynamic> json) =>
      Item(id: json["id"], name: json["name"]);

  Map<String, dynamic> toMap() => {"id": id, "name": name};
}

class Gudang {
  final int? id;
  final String? name;

  Gudang({this.id, this.name});

  factory Gudang.fromMap(Map<String, dynamic> json) =>
      Gudang(id: json["id"], name: json["name"]);

  Map<String, dynamic> toMap() => {"id": id, "name": name};
}
