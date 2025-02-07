import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:piki_admin/auth/services/auth_services.dart';
import 'package:piki_admin/auth/widgets/card_container.dart';
import 'package:piki_admin/shared/components/reusable_button.dart';
import 'package:piki_admin/shared/routes/app_navigator.dart';
import 'package:piki_admin/shared/routes/app_routes.dart';
import 'package:piki_admin/theme/app_theme.dart';

// Instancia global de Dio y SecureStorage
final Dio dio = Dio();
const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final AuthService authService = AuthService();

    final data = {
      'email': email,
      'password': password,
    };

    final bool isSuccess = await authService.login(context, data);

    if (isSuccess) {
      AppNavigator().navigateToPage(thePageRouteName: AppRoutes.mainPage);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isTokenExpired(String token) {
    try {
      final decodedToken = Jwt.parseJwt(token);
      final expiryDate =
          DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true; // Si ocurre un error, asumimos que el token no es válido.
    }
  }

  void _handleExpiredToken() async {
    await secureStorage.delete(key: 'token');
    // Aquí podrías usar un controlador global de navegación o mostrar un diálogo.
    // Por simplicidad, imprimiremos un mensaje.
    log('El token ha expirado. Por favor, inicia sesión de nuevo.');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/rose-petals.svg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Center(
            child: SingleChildScrollView(
              child: CardContainer(
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Piki Creativa - Admin',
                        style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GoldenChesse'),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Correo Electrónico',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ReusableButton(
                              childText: 'Iniciar Sesión',
                              onPressed: _handleLogin,
                              buttonColor: AppTheme.primary,
                              iconData: Icons.login,
                              childTextColor: Colors.white,
                              customHeight: 60,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
