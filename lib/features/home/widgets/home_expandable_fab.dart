import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:Modisch/core/constants/colors.dart';
import 'package:Modisch/core/constants/typography.dart';

class CustomExpandableFab extends StatelessWidget {
  const CustomExpandableFab({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      type: ExpandableFabType.fan,
      distance: 80.0,
      fanAngle: 70,
      duration: const Duration(milliseconds: 250),
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.tertiary,
        shape: const CircleBorder(),
      ),
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.close),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.disabled,
        shape: const CircleBorder(),
      ),
      overlayStyle: ExpandableFabOverlayStyle(
        blur: 5.0, // Blur effect strength
        color: Colors.white.withValues(alpha :0.5),
      ),
      children: [
        SizedBox(
          width: 150,
          child: FloatingActionButton.extended(
            heroTag: 'add_clothes',
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () => context.goNamed('camera_picker'),
            icon: const FaIcon(
              FontAwesomeIcons.camera,
              size: 16,
              color: AppColors.secondary,
            ),
            label: Text('Add Clothes', style: AppTypography.cardLabel(context)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 150,
          child: FloatingActionButton.extended(
            heroTag: 'make_model',
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed:
                () => context.goNamed('outfit_editor_new'),
            icon: const FaIcon(
              FontAwesomeIcons.shirt,
              size: 16,
              color: AppColors.secondary,
            ),
            label: Text('Make Model', style: AppTypography.cardLabel(context)),
          ),
        ),
      ],
    );
  }
}
