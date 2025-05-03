import 'package:flutter/cupertino.dart';

class OnBoardSubtitle extends StatelessWidget {
  final String text;
  const OnBoardSubtitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    );
  }
}
