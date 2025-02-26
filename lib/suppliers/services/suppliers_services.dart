import 'dart:developer';

import 'package:piki_admin/auth/services/auth_services.dart';
import 'package:piki_admin/shared/services/http_service.dart';
import 'package:piki_admin/suppliers/models/supplier_models.dart';

class SuppliersServices {
  final HttpService _http = HttpService();

  _setupAuth() async {
    final loggedUser = await AuthService().getUser();
    final token = loggedUser?['token'];
    _http.setAuthToken(token);
  }

  Future<List<Suppliers>> getSuppliers() async {
    try {
      await _setupAuth();
      //TODO: Cambiar la ruta de la petición esta allUser en vez de suppliers
      final response = await _http.get('/suppliers/allUsers');
      final List<dynamic> suppliersJson = response.data;
      return suppliersJson.map((json) => Suppliers.fromJson(json)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> createSupplier(Map<String, dynamic> supplier) async {
    try {
      await _setupAuth();

      final response = await _http.post('/suppliers', data: supplier);
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Material created successfully');
        return true;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
    return false;
  }

  Future<bool> updateSupplier(Map<String, dynamic> supplier, int id) async {
    try {
      await _setupAuth();
      final response = await _http.put('/suppliers/$id', data: supplier);
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Material updated successfully');
        return true;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
    return false;
  }

  Future<void> deleteSupplier(int id) async {
    try {
      await _setupAuth();
      await _http.delete('/suppliers/$id');
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
