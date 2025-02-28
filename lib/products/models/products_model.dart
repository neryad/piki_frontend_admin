// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final int isAvailable;
  final double offerPrice;
  final String imageUrl;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.isAvailable,
    required this.offerPrice,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"]?.toDouble(),
        stock: json["stock"],
        isAvailable: json["isAvailable"],
        offerPrice: json["offerPrice"]?.toDouble(),
        imageUrl: json["imageUrl"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "stock": stock,
        "isAvailable": isAvailable,
        "offerPrice": offerPrice,
        "imageUrl": imageUrl,
        "created_at": createdAt.toIso8601String(),
      };
}
