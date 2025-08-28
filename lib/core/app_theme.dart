import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: Colors.red[700],
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.red,

    backgroundColor: Colors.white,

    accentColor: Colors.black,
  ).copyWith(onSurface: Colors.black),

  scaffoldBackgroundColor: Colors.white,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    elevation: 4.0,
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),

    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
  ),
);
