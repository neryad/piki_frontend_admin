import 'package:flutter/material.dart';
import 'package:piki_admin/auth/pages/check_auth_screen.dart';
import 'package:piki_admin/shared/components/not_found_page.dart';
import 'package:piki_admin/shared/constants/environment.dart';
import 'package:piki_admin/shared/routes/app_navigator.dart';
import 'package:piki_admin/shared/routes/app_routes.dart';
import 'package:piki_admin/shared/routes/get_app_route.dart';
import 'package:piki_admin/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setEnvironmentConfig();
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piki Creativa - Admin',
      navigatorKey: AppNavigator().navigatorKey,
      scaffoldMessengerKey: AppNavigator().snackbarKey,
      initialRoute: AppRoutes.checkAuth,
      theme: AppTheme.lightTheme,
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
        return MaterialPageRoute(
          builder: (_) => const NotFoundScreen(),
        );
      },
      home: const CheckAuthScreen(),
    );
  }
}
