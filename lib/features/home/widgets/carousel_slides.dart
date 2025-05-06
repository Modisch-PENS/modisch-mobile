import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:Modisch/core/constants/colors.dart';
import 'package:Modisch/core/constants/typography.dart';

final List<Map<String, String>> carouselItems = [
  {
    'text': 'CREATE ENDLESS LOOKS WITH WHAT YOU OWN',
    'image': 'assets/carousel/model1.webp',
  },
  {
    'text': 'EXPRESS YOURSELF, ONE OUTFIT AT A TIME',
    'image': 'assets/carousel/model2.webp',
  },
  {
    'text': 'DECIDE WHAT YOU WANNA WEAR TODAY!',
    'image': 'assets/carousel/model3.webp',
  },
];

class CarouselContainer extends StatelessWidget {
  const CarouselContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        // aspectRatio: 2.0,
        enlargeCenterPage: false,
        viewportFraction: 1.0,
        scrollDirection: Axis.horizontal,
        autoPlay: true,
      ),
      items: _buildImageSliders(context),
    );
  }
}

List<Widget> _buildImageSliders(BuildContext context) {
  return carouselItems.map((item) {
    return Container(
      decoration: BoxDecoration(color: AppColors.weatherBox),
      margin: const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  item['text']!,
                  style: AppTypography.carouselText(context),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: Image.asset(
                  item['image']!,
                  fit: BoxFit.cover,
                  frameBuilder: (context, child, frame, _) {
                    if (frame == null) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.disabled,
                        ),
                      );
                    }
                    return child;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }).toList();
}
