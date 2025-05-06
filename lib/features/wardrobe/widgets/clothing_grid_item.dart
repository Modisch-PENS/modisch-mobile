import 'dart:io';
import 'package:flutter/material.dart';
import 'package:Modisch/core/constants/colors.dart';
import 'package:Modisch/core/constants/typography.dart';
import 'package:Modisch/core/database/models/wardrobe_database.dart';

class ClothingGridItem extends StatelessWidget {
  final ClothingModel item;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const ClothingGridItem({
    super.key,
    required this.item,
    this.onTap,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.disabled,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)),
                child: Image.file(
                  File(item.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                item.name,
                textAlign: TextAlign.center,
                style: AppTypography.cardLabel(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}