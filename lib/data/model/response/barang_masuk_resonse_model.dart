import 'dart:convert';

class BarangMasukResponse {
  final String? message;
  final bool? success;
  final List<Datum>? data;

  BarangMasukResponse({this.message, this.success, this.data});

  factory BarangMasukResponse.fromJson(String str) =>
      BarangMasukResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BarangMasukResponse.fromMap(Map<String, dynamic> json) =>
      BarangMasukResponse(
        message: json["message"],
        success: json["success"],
        data:
            json["data"] == null
                ? []
                : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
    "message": message,
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class Datum {
  final int? id;
  final int? itemId;
  final int? gudangId;
  final int? jumlah;
  final int? quantity;
  final DateTime? tanggalMasuk;
  final dynamic keterangan;
  final dynamic foto;
  final int? hargaBeli;
  final CreatedBy? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String? itemName;
  final String? gudangName;

  Datum({
    this.id,
    this.itemId,
    this.gudangId,
    this.quantity,
    this.tanggalMasuk,
    this.keterangan,
    this.foto,
    this.hargaBeli,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.jumlah,

    this.itemName,
    this.gudangName,
  });

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    itemId: json["item_id"],
    gudangId: json["gudang_id"],
    quantity: json["quantity"],
    tanggalMasuk:
        json["tanggal_masuk"] == null
            ? null
            : DateTime.parse(json["tanggal_masuk"]),
    keterangan: json["keterangan"],
    foto: json["foto"],
    hargaBeli: json["harga_beli"],
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
    "tanggal_masuk":
        "${tanggalMasuk!.year.toString().padLeft(4, '0')}-${tanggalMasuk!.month.toString().padLeft(2, '0')}-${tanggalMasuk!.day.toString().padLeft(2, '0')}",
    "keterangan": keterangan,
    "foto": foto,
    "harga_beli": hargaBeli,
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
