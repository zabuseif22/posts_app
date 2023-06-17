import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnakBar {
  void showSnakBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        )));
  }

  void showErrorSnakBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        )));
  }
}
