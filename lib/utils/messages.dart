import 'package:fluttertoast/fluttertoast.dart';
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


class ToastMsg {
  static void showToastMsg(BuildContext context, String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      // toastDuration: Duration(seconds: 2),
    );
  }
}
