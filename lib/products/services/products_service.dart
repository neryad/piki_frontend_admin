import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:piki_admin/auth/services/auth_services.dart';
import 'package:piki_admin/products/models/products_model.dart';
import 'package:piki_admin/shared/services/http_service.dart';

class ProductsService {
  final HttpService _http = HttpService();

  _setupAuth() async {
    final loggedUser = await AuthService().getUser();
    final token = loggedUser?['token'];
    _http.setAuthToken(token);
  }

  Future<List<Product>> getProducts() async {
    try {
      await _setupAuth();
      final response = await _http.get('/products');
      final List<dynamic> usersJson = response.data;
      return usersJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createProduct(Map<String, dynamic> formValues) async {
    try {
      await _setupAuth();

      final file = MultipartFile.fromBytes(
        formValues['imageBytes'],
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      );

      FormData formData = FormData.fromMap({
        'image': file,
        'name': formValues['name'],
        'description': formValues['description'],
        'price': formValues['price'],
        'stock': formValues['stock'],
        'offerPrice': formValues['offerPrice'],
        'isAvailable': formValues['isAvailable'],
      });

      await _http.post('/products', data: formData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(Map<String, dynamic> formValues, int id) async {
    try {
      await _setupAuth();

      final file = MultipartFile.fromBytes(
        formValues['imageBytes'],
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      );

      FormData formData = FormData.fromMap({
        'image': file,
        'name': formValues['name'],
        'description': formValues['description'],
        'price': formValues['price'],
        'stock': formValues['stock'],
        'offerPrice': formValues['offerPrice'],
        'isAvailable': formValues['isAvailable'] ? 1 : 0,
      });

      await _http.put('/products/$id', data: formData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _setupAuth();
      await _http.delete('/products/$id');
    } catch (e) {
      rethrow;
    }
  }
}
