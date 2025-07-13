import 'dart:convert';

class ProfilePegawaiResponse {
  final String? message;
  final bool? success;
  final Data? data;

  ProfilePegawaiResponse({this.message, this.success, this.data});

  factory ProfilePegawaiResponse.fromJson(String str) =>
      ProfilePegawaiResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProfilePegawaiResponse.fromMap(Map<String, dynamic> json) =>
      ProfilePegawaiResponse(
        message: json["message"],
        success: json["success"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "message": message,
    "success": success,
    "data": data?.toMap(),
  };
}

class Data {
  final int? id;
  final String? name;
  final String? email;
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? roleId;
  final Role? role;

  Data({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.roleId,
    this.role,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
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
    role: json["role"] == null ? null : Role.fromMap(json["role"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "role_id": roleId,
    "role": role?.toMap(),
  };
}

class Role {
  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Role({this.id, this.name, this.createdAt, this.updatedAt});

  factory Role.fromJson(String str) => Role.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Role.fromMap(Map<String, dynamic> json) => Role(
    id: json["id"],
    name: json["name"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
