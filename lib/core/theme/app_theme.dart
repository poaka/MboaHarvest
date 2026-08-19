import 'package:flutter/material.dart';

abstract final class AppColors {
  static const leaf = Color(0xFF216849);
  static const leafDark = Color(0xFF174A36);
  static const earth = Color(0xFF8B5E3C);
  static const mango = Color(0xFFF2B84B);
  static const canvas = Color(0xFFF8F6EF);
  static const ink = Color(0xFF1C2922);
}

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.leaf,
      surface: AppColors.canvas,
    ),
    scaffoldBackgroundColor: AppColors.canvas,
    useMaterial3: true,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: AppColors.ink,
        fontSize: 30,
        fontWeight: FontWeight.w800,
        height: 1.1,
      ),
      titleLarge: TextStyle(
        color: AppColors.ink,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(color: AppColors.ink, height: 1.45),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF0EEE6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.leaf, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.leaf,
        foregroundColor: AppColors.canvas,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
