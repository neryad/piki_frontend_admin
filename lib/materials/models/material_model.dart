// To parse this JSON data, do
//
//     final material = materialFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

MaterialModel materialFromJson(String str) =>
    MaterialModel.fromJson(json.decode(str));

String materialToJson(MaterialModel data) => json.encode(data.toJson());

class MaterialModel {
  final int id;
  final String name;
  final String description;
  final dynamic isAvailable;
  final double cost;
  final DateTime date;
  final int supplierId;
  final int quantity;
  final int quantityByUnit;
  final double costByUnit;
  final DateTime createdAt;

  MaterialModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isAvailable,
    required this.cost,
    required this.date,
    required this.supplierId,
    required this.quantity,
    required this.quantityByUnit,
    required this.costByUnit,
    required this.createdAt,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) => MaterialModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        isAvailable: json["isAvailable"],
        cost: json["cost"]?.toDouble(),
        date: DateTime.parse(json["date"]),
        supplierId: json["supplier_id"],
        quantity: json["quantity"],
        quantityByUnit: json["quantityByUnit"],
        costByUnit: json["costByUnit"]?.toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "isAvailable": isAvailable == 1 ? 'Disponible' : 'No disponible',
        "cost": cost,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "supplier_id": supplierId,
        "quantity": quantity,
        "quantityByUnit": quantityByUnit,
        "costByUnit": costByUnit,
        "created_at": createdAt.toIso8601String(),
      };
}
