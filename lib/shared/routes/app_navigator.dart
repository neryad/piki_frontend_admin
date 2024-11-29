import 'package:flutter/material.dart';

class AppNavigator {
  factory AppNavigator() => singleInstance;

  AppNavigator._internal();

  static AppNavigator singleInstance = AppNavigator._internal();

  //! Navigator KRYs

  final navigatorKey = GlobalKey<NavigatorState>();

  final snackbarKey = GlobalKey<ScaffoldMessengerState>();

  void goBack() => navigatorKey.currentState!.pop();

  //! Navigate to a page without replacing the previous page

  Future<void> navigateToPage({
    required String thePageRouteName,
    Object? arguments,
  }) async =>
      await navigatorKey.currentState!
          .pushNamed(thePageRouteName, arguments: arguments);

  //! Navigate to a page and replacing the previous page

  Future<void> navigationToReplacementPage({
    required String thePageRouteName,
    Object? arguments,
  }) async =>
      await navigatorKey.currentState!
          .pushReplacementNamed(thePageRouteName, arguments: arguments);

  //! Navigate to a page and replacing the previous page

  Future<void> pushNamedAndRemoveUntil({
    required String thePageRouteName,
    Object? arguments,
  }) async =>
      await navigatorKey.currentState!.pushNamedAndRemoveUntil(
          thePageRouteName, (route) => false,
          arguments: arguments);
}
