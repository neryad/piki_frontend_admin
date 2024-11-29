import 'package:flutter/material.dart';
import 'package:piki_admin/main/pages/main_page.dart';
import 'package:piki_admin/shared/routes/app_navigator.dart';
import 'package:piki_admin/shared/routes/app_routes.dart';
import 'package:piki_admin/shared/routes/get_app_route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();
  // setEnvironmentConfig();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainApp();
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  final List<String> _pages = [
    'dashboard',
    'user',
    'settings',
    // const UsersPage(),
    // const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotorPaint App',
      navigatorKey: AppNavigator().navigatorKey,
      scaffoldMessengerKey: AppNavigator().snackbarKey,
      initialRoute: AppRoutes.mainPage,
      onGenerateRoute: (RouteSettings settings) {
        final pageContentBuilder = AppRoutes.routes[settings.name];
        if (pageContentBuilder != null) {
          return GetPageRoute.route(
            routeName: settings.name,
            view: pageContentBuilder(context),
            args: settings.arguments,
          );
        }
        // Si la ruta no existe, devuelve una pantalla de error o predeterminada
        // return MaterialPageRoute(
        //   builder: (_) => const NotFoundScreen(),
        // );
      },
      home: const MainPage(),
    );
  }
}










// import 'package:piki_admin/dashboard/pages/dashboard_page.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(home: MainPage());
//     // return const MaterialApp(
//     //   home: Scaffold(
//     //     body: Center(
//     //       child: Text('Hello World!'),
//     //     ),
//     //   ),
//     // );
//   }
// }

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   _MainPageState createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     const DashboardPage(),
//     // const UsersPage(),
//     // const SettingsPage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Panel Administrativo'),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text(
//                 'Menú',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               title: const Text('Dashboard'),
//               onTap: () {
//                 _onItemTapped(0);
//                 Navigator.pop(context); // Cierra el menú
//               },
//             ),
//             ListTile(
//               title: const Text('Usuarios'),
//               onTap: () {
//                 _onItemTapped(1);
//                 Navigator.pop(context); // Cierra el menú
//               },
//             ),
//             ListTile(
//               title: const Text('Configuración'),
//               onTap: () {
//                 _onItemTapped(2);
//                 Navigator.pop(context); // Cierra el menú
//               },
//             ),
//           ],
//         ),
//       ),
//       body: _pages[_selectedIndex],
//     );
//   }
// }

// // class DashboardPage extends StatelessWidget {
// //   const DashboardPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Text('Página de Dashboard'),
// //     );
// //   }
// // }

// // class UsersPage extends StatelessWidget {
// //   const UsersPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Text('Página de Usuarios'),
// //     );
// //   }
// // }

// // class SettingsPage extends StatelessWidget {
// //   const SettingsPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Text('Página de Configuración'),
// //     );
// //   }
// // }
