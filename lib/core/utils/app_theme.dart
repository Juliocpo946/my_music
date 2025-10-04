import 'package:flutter/material.dart';
import 'package:my_music/core/utils/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.electricBlue,
      scaffoldBackgroundColor: AppColors.carbonDeep,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.electricBlue,
        secondary: AppColors.electricBlue,
        // CORRECCIÓN: 'background' -> 'surface'
        surface: AppColors.darkGrey,
        onPrimary: AppColors.pureWhite,
        onSecondary: AppColors.pureWhite,
        // CORRECCIÓN: 'onBackground' -> 'onSurface'
        onSurface: AppColors.pureWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.carbonDeep,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.pureWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.pureWhite),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.pureWhite),
        bodyMedium: TextStyle(color: AppColors.lightGrey),
        headlineLarge: TextStyle(
            color: AppColors.pureWhite,
            fontWeight: FontWeight.bold,
            fontSize: 32),
        headlineMedium: TextStyle(
            color: AppColors.pureWhite,
            fontWeight: FontWeight.bold,
            fontSize: 22),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.carbonDeep,
        selectedItemColor: AppColors.electricBlue,
        unselectedItemColor: AppColors.lightGrey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}