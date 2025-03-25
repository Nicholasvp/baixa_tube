import 'package:flutter/material.dart';

enum SnackbarType { success, error, warning, info }

class SnackbarApp {
  static void show(BuildContext context, String message, SnackbarType type) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 16.0),
      ),
      backgroundColor: _getColor(type),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Color _getColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Colors.blue;
      case SnackbarType.error:
        return Colors.red;
      case SnackbarType.warning:
        return Colors.orange;
      case SnackbarType.info:
        return Colors.white;
      default:
        return Colors.black;
    }
  }
}
