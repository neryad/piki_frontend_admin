import 'package:flutter/material.dart';

class GetPageRoute {
  factory GetPageRoute() => singleInstance;

  const GetPageRoute._internal();

  static const GetPageRoute singleInstance = GetPageRoute._internal();

  //! GET a Page Route

  static PageRoute<MaterialPageRoute<Widget?>> route({
    String? routeName,
    Widget? view,
    Object? args,
  }) =>
      MaterialPageRoute(
          settings: RouteSettings(name: routeName, arguments: args),
          builder: (_) => view!);
}
