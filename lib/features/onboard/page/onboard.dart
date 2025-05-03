import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/routes/router_provider.dart';
import 'package:modisch/features/onboard/riverpod/onboard_provider.dart';
import 'package:modisch/features/onboard/widget/animation.dart';
import 'package:modisch/features/onboard/widget/subtitle.dart';
import 'package:modisch/features/onboard/widget/title.dart';

class OnboardPage extends ConsumerWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnBoardingSlider(
      totalPage: 3,
      finishButtonText: 'Get Started',
      onFinish: () async {
        await ref.read(setOnboardedProvider.future);
        ref.read(routerProvider).goNamed('main');
      },
      finishButtonStyle: FinishButtonStyle(backgroundColor: AppColors.tertiary),
      skipTextButton: Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: AppColors.tertiary,
          fontWeight: FontWeight.w600,
        ),
      ),
      controllerColor: AppColors.tertiary,
      headerBackgroundColor: AppColors.background,
      //pageBackgroundColor: ,
      background: const [SizedBox(), SizedBox(), SizedBox()],
      speed: 1.8,
      pageBodies: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              OnBoardAnimation(assetPath: 'assets/onboard/onboard_1.json'),
              SizedBox(height: 30),
              OnBoardTitle(text: 'Welcome to Modisch'),
              OnBoardSubtitle(
                text:
                    'Organize your wardrobe and create perfect outfits easily',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              OnBoardAnimation(assetPath: 'assets/onboard/onboard_2.json'),
              SizedBox(height: 30),
              OnBoardTitle(text: 'Upload Your Clothes'),
              OnBoardSubtitle(
                text: 'Easily add clothes to your digital closet',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              OnBoardAnimation(assetPath: 'assets/onboard/onboard3.json'),
              SizedBox(height: 30),
              OnBoardTitle(text: 'Mix and Match'),
              OnBoardSubtitle(
                text: 'Combine your favourite pieces into stunning looks',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
