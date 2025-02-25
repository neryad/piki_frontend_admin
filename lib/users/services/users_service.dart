import 'package:piki_admin/auth/services/auth_services.dart';
import 'package:piki_admin/shared/services/http_service.dart';
import '../models/user_model.dart';

class UsersService {
  final HttpService _http = HttpService();

  _setupAuth() async {
    final loggedUser = await AuthService().getUser();
    final token = loggedUser?['token'];
    _http.setAuthToken(token);
  }

  Future<List<User>> getUsers() async {
    try {
      await _setupAuth();
      final response = await _http.get('/users/allUsers');
      final List<dynamic> usersJson = response.data;
      return usersJson.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getUserById(int id) async {
    try {
      await _setupAuth();
      final response = await _http.get('/users/$id');
      return User.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUser(
    Map<String, dynamic> user,
  ) async {
    try {
      await _setupAuth();
      var data = {
        "name": user['name'],
        "lastName": user['lastName'],
        "phone": user['phone'],
        "email": user['email'],
        "password": user['password'],
        "role_id": user['role_id'],
      };
      await _http.post('/users', data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future updateUser(
    Map<String, dynamic> user,
  ) async {
    try {
      await _setupAuth();
      final data = {
        "name": user['name'],
        "lastName": user['lastName'],
        "phone": user['phone'],
        "email": user['email'],
        "role_id": user['role_id'],
      };
      final id = user['id'];
      await _http.put('/users/$id', data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _setupAuth();
      await _http.delete('/users/$id');
    } catch (e) {
      rethrow;
    }
  }
}
