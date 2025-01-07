import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:piki_admin/auth/pages/services/auth_services.dart';
import 'package:piki_admin/shared/routes/app_navigator.dart';
import 'package:piki_admin/shared/routes/app_routes.dart';

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

    // try {
    //   final response = await dio.post(
    //     'http://localhost:3000/auth/login',
    //     data: {
    //       'email': email,
    //       'password': password,
    //     },
    //     options: Options(
    //       headers: {
    //         'Content-Type': 'application/json',
    //       },
    //     ),
    //   );

    //   if (response.statusCode == 200) {
    //     final data = response.data;

    //     if (data['loggedUser'] != null) {
    //       final user = data['loggedUser'];
    //       final token = user['token'];

    //       await secureStorage.write(key: 'token', value: token);

    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text('¡Bienvenido, ${user['name']}!')),
    //       );
    //       setState(() {
    //         _isLoading = false;
    //       });
    //       AppNavigator().navigateToPage(thePageRouteName: AppRoutes.mainPage);
    //     } else {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(
    //           content: Text('Error inesperado en la respuesta'),
    //         ),
    //       );
    //       setState(() {
    //         _isLoading = false;
    //       });
    //     }
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Error al iniciar sesión'),
    //       ),
    //     );
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   }
    // } on DioException catch (e) {
    //   final errorMessage = e.response?.data['message'] ?? 'Error de red';
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(errorMessage)),
    //   );
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Iniciar Sesión',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                      : ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text('Iniciar Sesión'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
