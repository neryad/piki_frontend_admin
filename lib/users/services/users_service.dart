import 'package:piki_admin/auth/services/auth_services.dart';
import 'package:piki_admin/shared/services/http_service.dart';
import '../models/user_model.dart';

class UsersService {
  final HttpService _http = HttpService();

  Future<List<User>> getUsers() async {
    try {
      final loggedUser = await AuthService().getUser();
      final token = loggedUser?['token'];
      _http.setAuthToken(token);
      final response = await _http.get('/users/allUsers');
      final List<dynamic> usersJson = response.data;
      return usersJson.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
