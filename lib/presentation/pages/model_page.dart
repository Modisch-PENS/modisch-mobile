import 'package:flutter/material.dart';
import 'package:modisch/constants/typography.dart';

class ModelPage extends StatefulWidget {
  const ModelPage({super.key});

  @override
  State<ModelPage> createState() => _ModelPageState();
}

class _ModelPageState extends State<ModelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Model Page", style: AppTypography.pageTitle(context)),
    );
  }
}