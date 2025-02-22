import 'package:piki_admin/auth/services/auth_services.dart';
import 'package:piki_admin/roles/models/role_model.dart';
import 'package:piki_admin/shared/services/http_service.dart';

class RoleService {
  final HttpService _http = HttpService();

  Future<List<Roles>> getRoles() async {
    try {
      final loggedUser = await AuthService().getUser();
      final token = loggedUser?['token'];
      _http.setAuthToken(token);
      final response = await _http.get('/roles');
      final List<dynamic> rolesJson = response.data;
      return rolesJson.map((json) => Roles.fromJson(json)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> createRole(String role) async {
    var data = {'name': role};
    try {
      final loggedUser = await AuthService().getUser();
      final token = loggedUser?['token'];
      _http.setAuthToken(token);
      await _http.post('/roles', data: data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateRole(int id, String role) async {
    var data = {'name': role};
    try {
      final loggedUser = await AuthService().getUser();
      final token = loggedUser?['token'];
      _http.setAuthToken(token);
      await _http.put('/roles/$id', data: data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteRole(int id) async {
    try {
      final loggedUser = await AuthService().getUser();
      final token = loggedUser?['token'];
      _http.setAuthToken(token);
      await _http.delete('/roles/$id');
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Roles> getRole(int id) async {
    try {
      final loggedUser = await AuthService().getUser();
      final token = loggedUser?['token'];
      _http.setAuthToken(token);
      final response = await _http.get('/roles/$id');
      return Roles.fromJson(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
