import 'dart:convert';

class ItemRequestModel {
  final String? name;
  final String? description;
  final double? price;
  final int? stock;
  final String? status;

  ItemRequestModel({
    this.name,
    this.description,
    this.price,
    this.stock,
    this.status,
  });

  factory ItemRequestModel.fromJson(String str) =>
      ItemRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ItemRequestModel.fromMap(Map<String, dynamic> json) =>
      ItemRequestModel(
        name: json["name"] as String?,
        description: json["description"] as String?,
        price: json["price"] != null ? (json["price"] as num).toDouble() : null,
        stock: json["stock"] as int?,
        status: json["status"] as String?,
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (name != null) map["name"] = name;
    if (description != null) map["description"] = description;
    if (price != null) map["price"] = price;
    if (stock != null) map["stock"] = stock;
    if (status != null) map["status"] = status;
    return map;
  }

  ItemRequestModel copyWith({
    String? name,
    String? description,
    double? price,
    int? stock,
    String? status,
  }) {
    return ItemRequestModel(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      status: status ?? this.status,
    );
  }
}
