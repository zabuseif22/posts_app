

import 'package:flutter/material.dart';

class MyAppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: Colors.blue,
      secondaryHeaderColor: Colors.orange,
      // Add more theme properties as needed
    );
  }

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      // Customize dark theme properties
    );
  }
}
