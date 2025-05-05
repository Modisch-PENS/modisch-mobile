import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class OnBoardAnimation extends StatelessWidget {
  final String assetPath;
  const OnBoardAnimation({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(assetPath, width: 300, height: 300);
  }
}