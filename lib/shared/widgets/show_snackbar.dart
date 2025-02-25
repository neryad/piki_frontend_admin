import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String snackMsg) {
  final snackBar = SnackBar(
    content: Text(snackMsg),
    action: SnackBarAction(
      label: 'cerrar',
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
