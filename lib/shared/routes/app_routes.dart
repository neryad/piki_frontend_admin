import 'package:piki_admin/auth/pages/check_auth_screen.dart';
import 'package:piki_admin/auth/pages/login_pages.dart';
import 'package:flutter/material.dart';
import 'package:piki_admin/main/pages/main_page.dart';
import 'package:piki_admin/roles/pages/roles_page.dart';
import 'package:piki_admin/users/pages/user_page.dart';

class AppRoutes {
  factory AppRoutes() => _instance;

  const AppRoutes._internal();

  static const AppRoutes _instance = AppRoutes._internal();

  //!Dashboard

  static const String dashBoard = "dashboard";

  //!Home

  static const String mainPage = "main-page";

  //!Login
  static const String login = 'login';

  //!Check Auth
  static const String checkAuth = 'check-auth';

  //!Users
  static const String users = 'users';

  //!Roles
  static const String roles = 'roles';

  //! Mapa de rutas y vistas correspondientes
  static final Map<String, Widget Function(BuildContext)> routes = {
    mainPage: (context) => const MainPage(),
    login: (context) => const LoginPage(),
    checkAuth: (context) => const CheckAuthScreen(),
    users: (context) => const UserPage(),
    roles: (context) => const RolesPages(),
  };
}
