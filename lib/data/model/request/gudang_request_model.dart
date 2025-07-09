import 'dart:convert';

class GudangRequestModel {
  final String? name;
  final String? address;
  final double? latitude;
  final double? longitude;

  GudangRequestModel({this.name, this.address, this.latitude, this.longitude});

  factory GudangRequestModel.fromJson(String str) =>
      GudangRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GudangRequestModel.fromMap(Map<String, dynamic> json) =>
      GudangRequestModel(
        name: json["name"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toMap() => {
    "name": name,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
  };
}
