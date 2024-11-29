import 'package:piki_admin/dashboard/pages/dashboard_page.dart';
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

  //! Mapa de rutas y vistas correspondientes
  static final Map<String, Widget Function(BuildContext)> routes = {
    dashBoard: (context) => const DashboardPage(),
    mainPage: (context) => const MainPage(),
  };
}
