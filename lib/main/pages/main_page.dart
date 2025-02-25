// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:piki_admin/auth/services/auth_services.dart';
import 'package:piki_admin/dashboard/pages/dashboard_page.dart';
import 'package:piki_admin/materials/pages/material_page.dart';
import 'package:piki_admin/roles/pages/roles_page.dart';
import 'package:piki_admin/shared/routes/app_navigator.dart';
import 'package:piki_admin/shared/routes/app_routes.dart';
import 'package:piki_admin/theme/app_theme.dart';
import 'package:piki_admin/users/pages/user_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget _selectedPage = const DashboardPage();
  final routePageList = [
    {
      'icon': Icons.dashboard,
      'title': 'Dashboard',
      'page': const DashboardPage(),
    },
    {
      'icon': Icons.offline_pin_rounded,
      'title': 'Materiales',
      'page': const MaterialsPage(),
    },
    {
      'icon': Icons.people,
      'title': 'Usuarios',
      'page': const UserPage(),
    },
    {
      'icon': Icons.tag,
      'title': 'Roles',
      'page': const RolesPages(),
    },
    {
      'icon': Icons.power_settings_new_outlined,
      'title': 'Cerrar sesión',
      'page': 'logout',
    },
  ];

  void _onItemTapped(dynamic object) {
    setState(() {
      _selectedPage = object['page'] as Widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Piki Creativa - Panel Administrativo',
          style: TextStyle(fontSize: 30),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.pinkSalmon,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ...routePageList.map((route) {
              return ListTile(
                leading: Icon(route['icon'] as IconData),
                title: Text(route['title'] as String),
                onTap: () {
                  if (route['page'] == 'logout') {
                    AuthService().logout();
                    AppNavigator().navigationToReplacementPage(
                        thePageRouteName: AppRoutes.login);
                    return;
                  }

                  _onItemTapped(route);
                  Navigator.pop(context); // Cierra el menú
                },
              );
            }),
          ],
        ),
      ),
      body: _selectedPage,
    );
  }
}
