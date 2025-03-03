import 'dart:developer';

import 'package:piki_admin/auth/services/auth_services.dart';
import 'package:piki_admin/products_materials/models/product_material_model.dart';
import 'package:piki_admin/shared/services/http_service.dart';

class ProductsMaterialService {
  final HttpService _http = HttpService();

  _setupAuth() async {
    final loggedUser = await AuthService().getUser();
    final token = loggedUser?['token'];
    _http.setAuthToken(token);
  }

  Future<List<ProductMaterials>> getProductsMaterials() async {
    try {
      await _setupAuth();
      final response = await _http.get('/productsMaterials/relation');
      final List<dynamic> productMaterialJson = response.data;
      return productMaterialJson
          .map((json) => ProductMaterials.fromJson(json))
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> createProductMaterial(Map<String, dynamic> formValues) async {
    try {
      await _setupAuth();
      await _http.post('/productsMaterials', data: formValues);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> updateProductMaterial(
      int id, Map<String, dynamic> formValues) async {
    try {
      await _setupAuth();
      await _http.put('/productsMaterials/$id', data: formValues);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteProductMaterial(int id) async {
    try {
      await _setupAuth();
      await _http.delete('/productsMaterials/$id');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
