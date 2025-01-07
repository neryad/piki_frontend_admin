import 'package:flutter/material.dart';
import 'package:piki_admin/auth/pages/services/auth_services.dart';

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
      body: Center(
        child: Text('Dashboard'),
      ),
    );
  }
}
