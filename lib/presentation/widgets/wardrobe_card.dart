import 'package:flutter/material.dart';
import '../../constants/colors.dart';


class WardrobeCard extends StatelessWidget {
  const WardrobeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
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
            debugPrint('Card tapped.');
          },
          child: const SizedBox(
            width: 160,
            height: 160,
            child: Text('A card that can be tapped'),
          ),
        ),
      ),
    );
  }
}
