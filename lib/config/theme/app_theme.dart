/* core/constants/colors.dart and typography.dart files define what your
brand colors and text styles are. and this config/theme/app_theme.dart is the layer that tells
Flutter how to apply those constants
across the whole MaterialApp.*/

// lib/config/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/typography.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.light(
        background: AppColors.background,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        onPrimary: AppColors.secondary,
        onSecondary: AppColors.primary,
      ),
      textTheme: TextTheme(
        headlineMedium: AppTypography.pageTitle,
        bodyLarge: AppTypography.categoryTabViewList,
        bodySmall: AppTypography.cardLabel,
        labelLarge: AppTypography.buttonLabel,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        elevation: 0,
        titleTextStyle: AppTypography.pageTitle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          textStyle: AppTypography.buttonLabel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTypography.inputTextPlaceholder,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondary),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.tertiary),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
