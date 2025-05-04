import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/typography.dart';

class WardrobeExpandableFab extends StatelessWidget {
  const WardrobeExpandableFab({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      type: ExpandableFabType.fan,
      distance: 80.0,
      fanAngle: 70,
      duration: const Duration(milliseconds: 250),
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add_a_photo),
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
        blur: 5.0,
        color: Colors.white.withOpacity(0.5),
      ),
      children: [
        SizedBox(
          width: 150,
          child: FloatingActionButton.extended(
            heroTag: 'camera',
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {
              context.goNamed('camera_picker');
            },
            icon: const FaIcon(
              FontAwesomeIcons.camera,
              size: 16,
              color: AppColors.secondary,
            ),
            label: Text('Camera', style: AppTypography.cardLabel(context)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 150,
          child: FloatingActionButton.extended(
            heroTag: 'gallery',
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {
              context.goNamed('gallery_picker');
            },
            icon: const FaIcon(
              FontAwesomeIcons.images,
              size: 16,
              color: AppColors.secondary,
            ),
            label: Text('Gallery', style: AppTypography.cardLabel(context)),
          ),
        ),
      ],
    );
  }
}
