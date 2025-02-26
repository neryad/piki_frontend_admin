import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piki_admin/auth/services/auth_services.dart';
import 'package:piki_admin/dashboard/pages/dashboard_page.dart';
import 'package:piki_admin/materials/pages/material_page.dart';
import 'package:piki_admin/roles/pages/roles_page.dart';
import 'package:piki_admin/shared/routes/app_navigator.dart';
import 'package:piki_admin/shared/routes/app_routes.dart';
import 'package:piki_admin/suppliers/pages/supplier_page.dart';
import 'package:piki_admin/theme/app_theme.dart';
import 'package:piki_admin/users/pages/user_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  Widget _selectedPage = const DashboardPage();
  int _selectedPageIndex = 0;
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
      'icon': Icons.account_box_rounded,
      'title': 'Suplidores',
      'page': const SupplierPage(),
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

  @override
  void initState() {
    super.initState();
    _loadSelectedPage();
  }

  Future<void> _loadSelectedPage() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedPageIndex = prefs.getInt('selectedPageIndex') ?? 0;
    setState(() {
      _selectedPageIndex = selectedPageIndex;
      _selectedPage = routePageList[selectedPageIndex]['page'] as Widget;
    });
  }

  Future<void> _saveSelectedPage(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedPageIndex', index);
  }

  Future<String> _getUserName() async {
    final user = await AuthService().getUser();
    return user != null ? '${user['name']} ${user['lastName']}' : 'No User';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
      _selectedPage = routePageList[index]['page'] as Widget;
    });
    _saveSelectedPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Piki Creativa - Panel Administrativo',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppTheme.pinkSalmon,
              ),
              child: FutureBuilder(
                future: _getUserName(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Cargando...');
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        ClipOval(
                          child: Image.network(
                            'https://eu.ui-avatars.com/api/?background=ff0077&color=FFFFFF&name=${snapshot.data}&bold=true',
                            fit: BoxFit.cover,
                            width: 100.0,
                            height: 100.0,
                          ),
                        ),
                        Text(
                          snapshot.data as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'GoldenChesse',
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text('Error al cargar el usuario');
                },
              ),
            ),
            ...routePageList.asMap().entries.map((entry) {
              int index = entry.key;
              var route = entry.value;
              return ListTile(
                leading: Icon(route['icon'] as IconData),
                title: Text(route['title'] as String),
                selected:
                    _selectedPageIndex == index, // Marca la opción seleccionada
                onTap: () {
                  if (route['page'] == 'logout') {
                    AuthService().logout();
                    _saveSelectedPage(0);
                    AppNavigator().navigationToReplacementPage(
                        thePageRouteName: AppRoutes.login);
                    return;
                  }

                  _onItemTapped(index);
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
