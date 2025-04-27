import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String image;
  final VoidCallback onTap;

  const ItemCard({super.key, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(image),
        ),
      ),
    );
  }
}
