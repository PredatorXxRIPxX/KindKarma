import 'package:flutter/material.dart';

void showErrorSnackBar(String message,BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        elevation: 7.0,
      ),
    );
  }

  void showSuccessSnackBar(String message,BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        elevation: 7.0,
      ),
    );
  }