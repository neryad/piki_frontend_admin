// To parse this JSON data, do
//
//     final suppliers = suppliersFromJson(jsonString);

import 'dart:convert';

List<Suppliers> suppliersFromJson(String str) =>
    List<Suppliers>.from(json.decode(str).map((x) => Suppliers.fromJson(x)));

String suppliersToJson(List<Suppliers> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Suppliers {
  int id;
  String name;
  String lastName;
  String phone;
  String email;
  DateTime createdAt;

  Suppliers({
    required this.id,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.createdAt,
  });

  factory Suppliers.fromJson(Map<String, dynamic> json) => Suppliers(
        id: json["id"],
        name: json["name"],
        lastName: json["lastName"],
        phone: json["phone"],
        email: json["email"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastName": lastName,
        "phone": phone,
        "email": email,
        "created_at": createdAt.toIso8601String(),
      };
}
