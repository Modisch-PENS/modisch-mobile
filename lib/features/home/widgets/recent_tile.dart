import 'package:flutter/material.dart';
import 'package:modisch/core/constants/colors.dart';
class RecentTile extends StatelessWidget {
  const RecentTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: const Center(
        child: Icon(Icons.add, size: 32, color: Colors.black),
      ),
    );
  }
}
