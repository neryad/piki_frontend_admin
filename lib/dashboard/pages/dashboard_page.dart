import 'package:flutter/material.dart';
import 'package:piki_admin/auth/services/auth_services.dart';
import 'package:piki_admin/theme/app_theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // authService.validateTokenExpiration();
    // authService.getUser();
    // final token = authService.getToken();
    // log(token);
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.build,
            size: 150,
            color: AppTheme.pinkSalmonShade100,
          ),
          Center(
            child: Text('Site under construction!',
                style: TextStyle(fontSize: 150, fontFamily: 'GoldenChesse')),
          ),
        ],
      ),
    );
  }
}
