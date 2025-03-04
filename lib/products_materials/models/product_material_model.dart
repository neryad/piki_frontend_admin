// To parse this JSON data, do
//
//     final productMaterials = productMaterialsFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

ProductMaterials productMaterialsFromJson(String str) =>
    ProductMaterials.fromJson(json.decode(str));

String productMaterialsToJson(ProductMaterials data) =>
    json.encode(data.toJson());

class ProductMaterials {
  final int id;
  final String materialName;
  final int materialId;
  final String productName;
  final int productId;
  final int quantityUsed;

  ProductMaterials({
    required this.id,
    required this.materialName,
    required this.materialId,
    required this.productName,
    required this.productId,
    required this.quantityUsed,
  });

  factory ProductMaterials.fromJson(Map<String, dynamic> json) =>
      ProductMaterials(
        id: json["id"],
        materialName: json["materialName"],
        materialId: json["materialId"],
        productName: json["productName"],
        productId: json["productId"],
        quantityUsed: json["quantityUsed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "materialName": materialName,
        "materialId": materialId,
        "productName": productName,
        "productId": productId,
        "quantityUsed": quantityUsed,
      };
}
