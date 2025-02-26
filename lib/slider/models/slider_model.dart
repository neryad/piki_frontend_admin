// To parse this JSON data, do
//
//     final sliderModel = sliderModelFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

SliderModel sliderModelFromJson(String str) =>
    SliderModel.fromJson(json.decode(str));

String sliderModelToJson(SliderModel data) => json.encode(data.toJson());

class SliderModel {
  final int id;
  final String imageUrl;
  final String link;
  final String isActive;

  SliderModel({
    required this.id,
    required this.imageUrl,
    required this.link,
    required this.isActive,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
        id: json["id"],
        imageUrl: json["imageUrl"],
        link: json["link"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imageUrl": imageUrl,
        "link": link,
        "isActive": isActive == 'true' ? 'Activo' : 'Inactivo',
      };
}
