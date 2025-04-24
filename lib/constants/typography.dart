import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';

class AppTypography {
  static TextTheme getM3TextTheme([TextTheme? base]) {
    return Typography.material2021(
      platform: TargetPlatform.android,
    ).black.merge(base ?? const TextTheme());
  }

  static TextStyle get pageTitle {
    return getM3TextTheme().headlineMedium!.copyWith(
      color: AppColors.secondary,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle get categoryTabViewList {
    return getM3TextTheme().bodyLarge!;
  }

  static TextStyle get inputTextPlaceholder {
    return getM3TextTheme().bodyLarge!;
  }

  static TextStyle get buttonLabel {
    return getM3TextTheme().labelLarge!.copyWith(fontWeight: FontWeight.w500);
  }

  static TextStyle get cardLabel {
    return getM3TextTheme().bodySmall!;
  }
}

