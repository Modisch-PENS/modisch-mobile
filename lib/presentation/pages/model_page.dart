import 'package:flutter/material.dart';
import 'package:modisch/presentation/widgets/model_card.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';

class ModelPage extends StatefulWidget {
  const ModelPage({super.key});

  @override
  _ModelPage createState() => _ModelPage();
}

class _ModelPage extends State<ModelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Model', style: AppTypography.pageTitle(context)),
        backgroundColor: AppColors.background,
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: Container(
        color: AppColors.background,
        child: const ModelCard(),
      ),
    );
  }
}