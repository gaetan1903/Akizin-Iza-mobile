import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    primaryColor: const Color(AppColors.primary),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(AppColors.primary)),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Lexend', // add font later
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Color(AppColors.dark),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF9F9FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE3E3E6)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE3E3E6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(AppColors.primary), width: 1.6),
      ),
      hintStyle: const TextStyle(color: Color(0xFF9FA1A8)),
      labelStyle: const TextStyle(color: Color(AppColors.dark), fontWeight: FontWeight.w500),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(AppColors.dark)),
      headlineMedium: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(AppColors.dark)),
      bodyMedium: TextStyle(fontSize: 16, color: Color(AppColors.dark)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(AppColors.primary),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color(AppColors.dark),
      contentTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      shape: StadiumBorder(),
    ),
  );
}
