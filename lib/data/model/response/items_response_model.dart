import 'dart:convert';

class ItemsResponse {
  final String? message;
  final bool? success;
  final List<ItemsDatum>? data;

  ItemsResponse({this.message, this.success, this.data});

  factory ItemsResponse.fromJson(String str) =>
      ItemsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ItemsResponse.fromMap(Map<String, dynamic> json) => ItemsResponse(
    message: json["message"],
    success: json["success"],
    data:
        json["data"] == null
            ? []
            : List<ItemsDatum>.from(json["data"]!.map((x) => ItemsDatum.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "message": message,
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class ItemsDatum {
  final int? id;
  final String? name;
  final String? description;
  final String? price;
  final int? stock;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ItemsDatum({
    this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ItemsDatum.fromJson(String str) => ItemsDatum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ItemsDatum.fromMap(Map<String, dynamic> json) => ItemsDatum(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    stock: json["stock"],
    status: json["status"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "stock": stock,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
