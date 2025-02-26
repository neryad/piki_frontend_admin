// import 'dart:developer';

import 'package:piki_admin/auth/services/auth_services.dart';
import 'package:piki_admin/shared/services/http_service.dart';
import 'package:piki_admin/slider/models/slider_model.dart';

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
}
