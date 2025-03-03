import 'package:piki_admin/auth/pages/check_auth_screen.dart';
import 'package:piki_admin/auth/pages/login_pages.dart';
import 'package:flutter/material.dart';
import 'package:piki_admin/main/main_page.dart';

class AppRoutes {
  factory AppRoutes() => _instance;

  const AppRoutes._internal();

  static const AppRoutes _instance = AppRoutes._internal();

  //!Home

  static const String mainPage = "home";

  //!Login
  static const String login = 'login';

  //!Check Auth
  static const String checkAuth = 'check-auth';

  //! Mapa de rutas y vistas correspondientes
  static final Map<String, Widget Function(BuildContext)> routes = {
    mainPage: (context) => const MainPage(),
    login: (context) => const LoginPage(),
    checkAuth: (context) => const CheckAuthScreen(),
  };
}
