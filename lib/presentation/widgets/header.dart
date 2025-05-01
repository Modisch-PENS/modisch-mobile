import 'package:flutter/material.dart';
import 'package:modisch/constants/typography.dart';

class Header extends StatelessWidget {
  final String nameHeader;

  const Header({super.key, required this.nameHeader});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            nameHeader,
            style: AppTypography.pageTitle(context),
          )
        ],
      ),
    );
  }
}