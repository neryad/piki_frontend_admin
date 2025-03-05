import 'package:dio/dio.dart';
import 'package:piki_admin/auth/services/auth_services.dart';
import 'package:piki_admin/shared/services/http_service.dart';
import 'package:piki_admin/slider/models/slider_model.dart';
import 'package:http_parser/http_parser.dart';

class SliderService {
  final HttpService _http = HttpService();

  _setupAuth() async {
    final loggedUser = await AuthService().getUser();
    final token = loggedUser?['token'];
    _http.setAuthToken(token);
  }

  Future<List<SliderModel>> getSliders() async {
    try {
      await _setupAuth();
      final response = await _http.get('/sliders');
      final List<dynamic> slidersJson = response.data;
      return slidersJson.map((json) => SliderModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createSlider(Map<String, dynamic> formValues) async {
    try {
      await _setupAuth();

      // Convertir Uint8List a MultipartFile
      final file = MultipartFile.fromBytes(
        formValues['imageBytes'],
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      );

      // Crear el FormData correctamente
      FormData formData = FormData.fromMap({
        'image': file,
        'link': formValues['link'],
        'isActive': formValues['isActive'],
      });

      await _http.post('/sliders', data: formData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSlider(Map<String, dynamic> formValues, int id) async {
    try {
      await _setupAuth();

      // Convertir Uint8List a MultipartFile
      final file = MultipartFile.fromBytes(
        formValues['imageBytes'],
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      );

      // Crear el FormData correctamente
      FormData formData = FormData.fromMap({
        'image': file,
        'link': formValues['link'],
        'isActive': formValues['isActive'] ? 1 : 0,
      });

      await _http.put('/sliders/$id', data: formData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSlider(int id) async {
    try {
      await _setupAuth();
      await _http.delete('/sliders/$id');
    } catch (e) {
      rethrow;
    }
  }
}
