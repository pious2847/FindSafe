import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showCustomSnackBar(BuildContext context, String message, Color backgroundColor) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
