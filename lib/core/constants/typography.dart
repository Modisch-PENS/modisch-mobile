import 'package:flutter/material.dart';
import 'package:modisch/core/constants/colors.dart';

class AppTypography {
  static TextTheme getM3TextTheme([TextTheme? base]) {
    return Typography.material2021(
      platform: TargetPlatform.android,
    ).black.merge(base ?? const TextTheme());
  }

  /// Returns the text style for page titles.
  static TextStyle pageTitle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
      color: AppColors.secondary,
      fontWeight: FontWeight.w500,
    );
  }

  /// Returns the text style for category tab view lists.
  static TextStyle categoryTabViewList(BuildContext context) {
    return getM3TextTheme(Theme.of(context).textTheme).bodyLarge!;
  }

  /// Returns the text style for search bar hint text.
  static TextStyle searchBarHintText(BuildContext context) {
    return getM3TextTheme(Theme.of(context).textTheme).bodyLarge!;
  }

  /// Returns the text style for input text placeholders.
  static TextStyle inputTextPlaceholder(BuildContext context) {
    return getM3TextTheme(Theme.of(context).textTheme).bodyLarge!;
  }

  /// Returns the text style for button labels.
  static TextStyle buttonLabel(BuildContext context) {
    return getM3TextTheme(
      Theme.of(context).textTheme,
    ).labelLarge!.copyWith(fontWeight: FontWeight.w500);
  }

  /// Returns the text style for card labels.
  static TextStyle cardLabel(BuildContext context) {
    return getM3TextTheme(Theme.of(context).textTheme).bodySmall!;
  }
}