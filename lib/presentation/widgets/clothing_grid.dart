import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:modisch/constants/typography.dart';
import 'package:modisch/models/clothing_item.dart';

class ClothingGrid extends StatelessWidget {
  final List <ClothingItem> items;

  const ClothingGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 0.85
        ),
        itemBuilder: (context, index){
          final item = items[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ 
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.disabled
                  ),
                  color: AppColors.primary
                ),
                child: ClipRRect(
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.name,
                style: AppTypography.cardLabel(context),
                textAlign: TextAlign.center,
              )
            ],
          );
        }
      ),
    );
  }
}