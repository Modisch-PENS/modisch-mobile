import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../models/wardrobe_item.dart';

class WardrobeCard extends StatelessWidget {
  final WardrobeItem item;

  const WardrobeCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      color: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Color(0xFFD9D9D9), width: 1.0),
      ),
      child: InkWell(
        splashColor: AppColors.disabled.withAlpha(30),
        onTap: () {
          debugPrint('${item.name} tapped.');
        },
        child: SizedBox(
          width: 160,
          height: 160,
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
