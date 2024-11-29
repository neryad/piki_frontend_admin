import 'package:flutter/material.dart';
import 'package:piki_admin/dashboard/pages/dashboard_page.dart';
import 'package:piki_admin/shared/routes/app_navigator.dart';
import 'package:piki_admin/shared/routes/app_routes.dart';
import 'package:piki_admin/users/pages/user_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const UserPage()
    // const UsersPage(),
    // const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Administrativo'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                _onItemTapped(0);
                // AppNavigator()
                //     .navigateToPage(thePageRouteName: AppRoutes.dashBoard);
                Navigator.pop(context); // Cierra el menú
              },
            ),
            ListTile(
              title: const Text('Usuarios'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context); // Cierra el menú
              },
            ),
            ListTile(
              title: const Text('Configuración'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context); // Cierra el menú
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
