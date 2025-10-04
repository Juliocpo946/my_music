import 'package:flutter/material.dart';
import 'package:my_music/core/utils/app_colors.dart';

class AppTheme {
  static ThemeData darkTheme(Color accentColor) {
    return ThemeData(
        primaryColor: accentColor,
        scaffoldBackgroundColor: AppColors.carbonDeep,
        colorScheme: ColorScheme.dark(
          primary: accentColor,
          secondary: accentColor,
          surface: AppColors.darkGrey,
          onPrimary: AppColors.pureWhite,
          onSecondary: AppColors.pureWhite,
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
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.carbonDeep,
          selectedItemColor: accentColor,
          unselectedItemColor: AppColors.lightGrey,
          type: BottomNavigationBarType.fixed,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: accentColor,
            )),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: accentColor,
          ),
        ),
        chipTheme: ChipThemeData(
          selectedColor: accentColor,
          backgroundColor: AppColors.darkGrey,
          labelStyle: const TextStyle(color: Colors.white),
          secondaryLabelStyle: const TextStyle(color: Colors.white),
        ));
  }
}