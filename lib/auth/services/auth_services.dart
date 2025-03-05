// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:piki_admin/shared/constants/environment.dart';

class AuthService {
  final _dio = Dio();
  final _storage = const FlutterSecureStorage();
  AuthService();

  Future<bool> login(BuildContext context, Map<String, dynamic> data) async {
    try {
      final endpoint = '${apiUrl}auth/login';
      final response = await _dio.post(
        endpoint,
        data: data,
      );
      // log(response);
      if (response.statusCode == 200) {
        final token = response.data['loggedUser']['token'];
        await saveToken(token);
        await saveUser(response.data['loggedUser']);
        // await getLoggedUser();
        return true;
      }
      return false;
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] ?? 'Ocurrió un error';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$message'),
          ),
        );
        // showSnackBar(context, '$message');
      } else {
        log('Error Message: ${e.message}');
      }
      return false;
    } catch (e) {
      log('Error Message: $e');
      return false;
    }
  }

  // Future<void> requestPasswordReset(
  //     BuildContext context, Map<String, dynamic> data) async {
  //   try {
  //     showLoaderDialog(context);
  //     final endpoint = '${API_URL}Accounts/reset-password';
  //     final response = await _dio.post(
  //       endpoint,
  //       data: data,
  //     );
  //     if (response.statusCode == 200) {
  //       Navigator.pop(context);
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return const CustomDialog(
  //               title: 'Solicitud enviada',
  //               descriptions:
  //                   'Se ha enviado un correo electrónico con las próximas instrucciones para restablecer su contraseña.',
  //               text: 'Cerrar',
  //               icon: Icons.done);
  //         },
  //       );
  //     }
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       final message =
  //           e.response?.data['message'] ?? 'Ocurrió un error desconocido';
  //       Navigator.pop(context);
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return CustomDialog(
  //             title: 'Ocurrió un error',
  //             descriptions: message,
  //             text: 'Cerrar',
  //             icon: Icons.cancel,
  //           );
  //         },
  //       );
  //     } else {
  //       log('Error Message: ${e.message}');
  //     }
  //   } catch (e) {
  //     log('Error Message: $e');
  //   }
  // }

  // Future<void> changePassword(
  //     BuildContext context, Map<String, dynamic> data) async {
  //   try {
  //     showLoaderDialog(context);
  //     final endpoint = '${API_URL}Accounts/change-password';
  //     final response = await _dio.post(
  //       endpoint,
  //       data: data,
  //     );
  //     if (response.statusCode == 200) {
  //       Navigator.pop(context);
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return CustomDialog(
  //               title: 'Cambio realizado',
  //               descriptions: response.data['message'],
  //               text: 'Cerrar',
  //               icon: Icons.done);
  //         },
  //       );
  //     }
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       final message =
  //           e.response?.data['message'] ?? 'Ocurrió un error desconocido';
  //       Navigator.pop(context);
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return CustomDialog(
  //             title: 'Ocurrió un error',
  //             descriptions: message,
  //             text: 'Cerrar',
  //             icon: Icons.cancel,
  //           );
  //         },
  //       );
  //     } else {
  //       log('Error Message: ${e.message}');
  //     }
  //   } catch (e) {
  //     log('Error Message: $e');
  //   }
  // }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
    await _storage.write(
      key: 'loginTime',
      value: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    log('Token saved');
  }

  // void validateTokenExpiration() async {
  //   final token = await _storage.read(key: 'token');
  //   try {
  //     Map<String, dynamic> payload = Jwt.parseJwt(token!);
  //     int exp = payload['exp'];
  //     if (exp != null) {
  //       final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  //       final currentDate = DateTime.now();
  //       if (currentDate.isBefore(expirationDate)) {
  //         print('Token is valid until $expirationDate');
  //       } else {
  //         AppNavigator().navigateToPage(thePageRouteName: 'login');
  //         clearToken();
  //         deleteUser();
  //         print('Token has expired');
  //       }
  //     } else {
  //       print('Token does not have an expiration date');
  //     }
  //   } catch (e) {
  //     print('Invalid token: $e');
  //   }
  // }

  Future<bool> validateTokenExpiration() async {
    final token = await _storage.read(key: 'token');
    if (token == null) {
      return false;
    }
    try {
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      int exp = payload['exp'];
      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final currentDate = DateTime.now();
      if (currentDate.isBefore(expirationDate)) {
        log('Token is valid until $expirationDate');
        return true;
      } else {
        log('Token has expired');
        await clearToken();
        await deleteUser();
        return false;
      }
    } catch (e) {
      log('Invalid token: $e');
      return false;
    }
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'loginTime');
    log('Session cleared');
  }

  Future<void> saveUser(Map<String, dynamic> userInfo) async {
    String userJson = jsonEncode(userInfo);
    await _storage.write(key: 'userInfo', value: userJson);
  }

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson = await _storage.read(key: 'userInfo');
    if (userJson != null) {
      log('User found $userJson');
      return jsonDecode(userJson);
    }
    log('Not user found');
    return null;
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: 'userInfo');
  }

  Future<void> logout() async {
    await clearToken();
    await deleteUser();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}
