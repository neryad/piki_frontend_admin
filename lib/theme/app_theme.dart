import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xffFFC8DD);
  static const Color pinkSalmon = Color(0xffff99b8);
  static const Color pinkSalmonShade100 = Color(0xffff7092);
  static const Color pinkSalmonShade200 = Color(0xffff4d7f);
  static const Color radicalRed = Color(0xffff2969);
  static const Color rose = Color(0xffff0077);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: radicalRed,
    appBarTheme: const AppBarTheme(
      elevation: 1,
      color: primary,
      toolbarHeight: 75,
      titleTextStyle: TextStyle(
        fontFamily: 'GoldenChesse',
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: Colors.black38),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
          borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
  );
}
