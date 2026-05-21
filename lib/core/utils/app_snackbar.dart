import 'package:flutter/material.dart';

class AppSnackbar {
  static void show(BuildContext context, String message) {
    debugPrint('[Snackbar] $message');
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
