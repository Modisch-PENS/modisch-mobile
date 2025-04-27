import 'dart:io';
import 'package:flutter/material.dart';
import '../../constants/typography.dart';
import '../../constants/colors.dart';

class ConfirmClothesPage extends StatelessWidget {
  final File imageFile;

  const ConfirmClothesPage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm Outfit',
          style: AppTypography.pageTitle,
        ),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Retake',
                    style: AppTypography.cardLabel.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  onPressed: () {
                    // TODO: Add your confirmation logic here
                    // For example, save to database or process the image
                    Navigator.pushReplacementNamed(context, '/wardrobe');
                  },
                  child: Text(
                    'Confirm',
                    style: AppTypography.cardLabel.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}