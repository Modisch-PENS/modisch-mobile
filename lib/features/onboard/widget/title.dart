import 'package:flutter/cupertino.dart';

class OnBoardTitle extends StatelessWidget {
  final String text;
  const OnBoardTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
