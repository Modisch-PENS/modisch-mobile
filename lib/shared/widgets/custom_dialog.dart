import 'package:flutter/material.dart';
import 'package:Modisch/core/constants/colors.dart';
import 'package:Modisch/core/constants/typography.dart';

// komponen buat bikin dialog konfirmasi dan discard

enum DialogType { confirm, discard }

class DialogConfig {
  final String primaryLabel;
  final String secondaryLabel;
  final Color primaryColor;

  const DialogConfig({
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.primaryColor,
  });
}

const Map<DialogType, DialogConfig> dialogConfigs = {
  DialogType.confirm: DialogConfig(
    primaryLabel: 'Confirm',
    secondaryLabel: 'Cancel',
    primaryColor: Colors.blue,
  ),
  DialogType.discard: DialogConfig(
    primaryLabel: 'Cancel',
    secondaryLabel: 'Discard',
    primaryColor: AppColors.secondary,
  ),
};

Future<void> showCustomDialog({
  required BuildContext context,
  required DialogType type,
  required String title,
  required String message,
  VoidCallback? onConfirmed,
  bool barrierDismissible = false,
}) async {
  final config = dialogConfigs[type]!;

  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder:
        (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(title, style: AppTypography.pageTitle(context)),
          content: Text(message, style: AppTypography.cardLabel(context)),
          actions: [
            // Secondary button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(foregroundColor: AppColors.disabled),
              child: Text(config.secondaryLabel),
            ),
            // Primary button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: config.primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirmed?.call();
              },
              child: Text(config.primaryLabel),
            ),
          ],
        ),
  );
}
