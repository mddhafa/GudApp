import 'dart:convert';

class PegawaiRequestModel {
  final String name;
  final String address;
  final String phone;

  PegawaiRequestModel({
    required this.name,
    required this.address,
    required this.phone,
  });

  factory PegawaiRequestModel.fromJson(String str) =>
      PegawaiRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PegawaiRequestModel.fromMap(Map<String, dynamic> json) =>
      PegawaiRequestModel(
        name: json["name"] ?? '',
        address: json["address"] ?? '',
        phone: json["phone"] ?? '',
      );

  Map<String, String> toMap() {
    return {"name": name, "address": address, "phone": phone};
  }
}
