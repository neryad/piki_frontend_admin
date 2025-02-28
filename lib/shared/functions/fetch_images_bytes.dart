import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';

Future<Uint8List?> fetchImageBytes(String imageUrl) async {
  try {
    final response = await Dio().get(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.statusCode == 200) {
      return Uint8List.fromList(response.data);
    }
  } catch (e) {
    log('Error descargando la imagen: $e');
  }
  return null;
}
