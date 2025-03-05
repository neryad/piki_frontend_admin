import 'dart:developer';

import 'package:piki_admin/auth/services/auth_services.dart';
import 'package:piki_admin/materials/models/material_model.dart';
import 'package:piki_admin/shared/services/http_service.dart';

class MaterialsService {
  final HttpService _http = HttpService();

  _setupAuth() async {
    final loggedUser = await AuthService().getUser();
    final token = loggedUser?['token'];
    _http.setAuthToken(token);
  }

  Future<List<MaterialModel>> getMaterials() async {
    try {
      await _setupAuth();
      final response = await _http.get('/materials');
      final List<dynamic> materialsJson = response.data;
      return materialsJson.map((json) => MaterialModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> postMaterial(Map<String, dynamic> payload) async {
    try {
      await _setupAuth();
      final response = await _http.post('/materials', data: payload);
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Material created successfully');
        return true;
      }
    } catch (e) {
      log('Error creating material: $e');
      rethrow;
    }
    return false;
  }

  Future<bool> updateMaterial(Map<String, dynamic> payload, int id) async {
    try {
      await _setupAuth();
      final response = await _http.put('/materials/$id', data: payload);
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Material updated successfully');
        return true;
      }
    } catch (e) {
      log('Error updating material: $e');
      rethrow;
    }
    return false;
  }

  Future<void> deleteMaterial(int id) async {
    try {
      await _setupAuth();
      await _http.delete('/materials/$id');
    } catch (e) {
      rethrow;
    }
  }
}
