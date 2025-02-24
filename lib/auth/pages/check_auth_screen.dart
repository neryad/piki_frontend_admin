// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:piki_admin/auth/services/auth_services.dart';
import 'package:piki_admin/shared/routes/app_routes.dart';
import '../../shared/routes/app_navigator.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.getUser(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.data == false || snapshot.data == null) {
              Future.microtask(() {
                AppNavigator().navigationToReplacementPage(
                    thePageRouteName: AppRoutes.login);
              });
            } else {
              Future.microtask(() {
                AppNavigator().navigationToReplacementPage(
                    thePageRouteName: AppRoutes.mainPage);
              });
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
