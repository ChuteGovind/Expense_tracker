import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData(useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF5F7FB),
          surfaceTintColor: Colors.transparent,
          elevation: 0),
      cardTheme: const CardThemeData(
          elevation: 0, margin: EdgeInsets.zero, color: Colors.white),
      inputDecorationTheme: const InputDecorationTheme(filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(color: Color(0xFFE5E7EB))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(color: Color(0xFFE5E7EB))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(color: Color(0xFF2563EB), width: 1.5))));
}

