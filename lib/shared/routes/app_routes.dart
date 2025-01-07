import 'package:piki_admin/auth/pages/login_pages.dart';
import 'package:flutter/material.dart';
import 'package:piki_admin/main/pages/main_page.dart';

class AppRoutes {
  factory AppRoutes() => _instance;

  const AppRoutes._internal();

  static const AppRoutes _instance = AppRoutes._internal();

  //!Home

  static const String dashBoard = "dashboard";

  //!Home

  static const String mainPage = "main-page";

  //!Login
  static const String login = 'login';

  //! Mapa de rutas y vistas correspondientes
  static final Map<String, Widget Function(BuildContext)> routes = {
    mainPage: (context) => const MainPage(),
    login: (context) => const LoginPage(),
  };
}
