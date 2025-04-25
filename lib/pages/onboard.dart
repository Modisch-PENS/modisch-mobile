import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:gap/gap.dart';
import 'package:modisch/constants/typography.dart';
import 'package:modisch/constants/button.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/logo/logo_no_rectangle.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background,
                    AppColors.disabled,
                    AppColors.secondary,
                    AppColors.secondary,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Gap(10),
                  Text(
                    'Mix, Match, Modisch',
                    textAlign: TextAlign.center,
                    style: AppTypography.pageTitle.copyWith(
                      color: AppColors.secondary,
                      fontSize: 30,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(30),
                  AppButton.secondary(
                    label: 'Get Started',
                    onPressed: () {
                      Navigator.pushNamed(context, '/dashboard');
                    },
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
