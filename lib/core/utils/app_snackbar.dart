import 'package:flutter/material.dart';

class AppSnackbar {
  /// Strips technical prefixes like "Exception:" / "Error:" that leak into
  /// messages built from `e.toString()`, so users see a clean sentence.
  static String cleanMessage(String message) {
    var m = message.trim();
    // Remove leading "Exception:", "Error:", "FormatException:", etc. — one or
    // more times (some errors are doubly wrapped).
    final prefix = RegExp(r'^[A-Za-z]*(Exception|Error)\s*:\s*', caseSensitive: false);
    while (prefix.hasMatch(m)) {
      m = m.replaceFirst(prefix, '').trim();
    }
    if (m.isEmpty) return 'Something went wrong. Please try again.';
    return m;
  }

  static void show(BuildContext context, String message) {
    final clean = cleanMessage(message);
    debugPrint('[Snackbar] $clean');
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(clean)));
  }
}
