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
        background: AppColors.carbonDeep,
        surface: AppColors.darkGrey,
        onPrimary: AppColors.pureWhite,
        onSecondary: AppColors.pureWhite,
        onBackground: AppColors.pureWhite,
        onSurface: AppColors.pureWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.carbonDeep,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.pureWhite),
        bodyMedium: TextStyle(color: AppColors.lightGrey),
      ),
    );
  }
}