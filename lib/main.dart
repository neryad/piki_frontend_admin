import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:piki_admin/main/pages/main_page.dart';
import 'package:piki_admin/shared/components/not_found_page.dart';
import 'package:piki_admin/shared/routes/app_navigator.dart';
import 'package:piki_admin/shared/routes/app_routes.dart';
import 'package:piki_admin/shared/routes/get_app_route.dart';
import 'package:piki_admin/auth/pages/login_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // await Hive.initFlutter();
  // setEnvironmentConfig();
  setupDioInterceptor();


  runApp(const AppState());
}

void setupDioInterceptor() {
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await secureStorage.read(key: 'token');
        if (token != null) {
          if (_isTokenExpired(token)) {
            // Si el token ha expirado, redirigir al login
            _handleExpiredToken();
            return handler.reject(
              DioException(
                requestOptions: options,
                error:
                    'El token ha expirado. Redirigiendo al inicio de sesión.',
              ),
            );
          } else {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          _handleExpiredToken();
        }
        return handler.next(e);
      },
    ),
  );
}

bool _isTokenExpired(String token) {
  try {
    final decodedToken = Jwt.parseJwt(token);
    final expiryDate =
        DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
    print(expiryDate);
    return DateTime.now().isAfter(expiryDate);
  } catch (e) {
    return true; // Si ocurre un error, asumimos que el token no es válido.
  }
}

void _handleExpiredToken() async {
  await secureStorage.delete(key: 'token');
  // Aquí podrías usar un controlador global de navegación o mostrar un diálogo.
  // Por simplicidad, imprimiremos un mensaje.
  print('El token ha expirado. Por favor, inicia sesión de nuevo.');
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

  final int _selectedIndex = 0;

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
      title: 'Piki Creativa - Admin',
      navigatorKey: AppNavigator().navigatorKey,
      scaffoldMessengerKey: AppNavigator().snackbarKey,
      initialRoute: AppRoutes.login,
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
      home: const MainPage(),
    );
  }
}
