import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:modisch/constants/typography.dart';

class AppButton {
  static Widget primary({
    required String label,
    required VoidCallback onPressed,
    bool isFullWidth = true,
    double height = 48,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tertiary,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.buttonLabel.copyWith(
            color: AppColors.background,
          ),
        ),
      ),
    );
  }

  static Widget secondary({
    required String label,
    required VoidCallback onPressed,
    bool isFullWidth = true,
    double height = 48,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.buttonLabel.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  static Widget tertiary({
    required String label,
    required VoidCallback onPressed,
    bool isFullWidth = true,
    double height = 48,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tertiary,
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.buttonLabel.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
