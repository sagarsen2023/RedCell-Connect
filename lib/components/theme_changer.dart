import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Colors.white,
    primary: Colors.black,
    secondary: Colors.red,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Colors.black,
    primary: Colors.white,
    secondary: Colors.red,
  ),
);

const TextStyle preText = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

const TextStyle suffText = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.red,
);
