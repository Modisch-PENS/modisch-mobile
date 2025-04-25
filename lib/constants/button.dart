import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:modisch/constants/typography.dart';

class AppButton {
  static Widget secondary({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
    bool fullWidth = true,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
      label: Text(
        label,
        style: AppTypography.buttonLabel.copyWith(color: AppColors.secondary),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        minimumSize: fullWidth ? const Size.fromHeight(48) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
