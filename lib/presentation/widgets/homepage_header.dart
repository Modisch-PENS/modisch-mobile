import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:modisch/constants/typography.dart';

class HomepageHeader extends StatelessWidget {
  const HomepageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Hello User', style: AppTypography.pageTitle(context)),
          // Container(
          //   width: 40,
          //   height: 40,
          //   decoration: BoxDecoration(
          //     color: AppColors.secondary,
          //     shape: BoxShape.circle,
          //   ),
          //   child: const Icon(Icons.person, color: Colors.white),
          // ),
          const CircleAvatar(
            backgroundColor: AppColors.secondary,
            child: Icon(Icons.person, color: AppColors.background),
          ),
        ],
      ),
    );
  }
}
