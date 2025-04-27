import 'package:flutter/material.dart';
import 'package:modisch/core/constants/typography.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.cardLabel(context),
    );

  }
}
