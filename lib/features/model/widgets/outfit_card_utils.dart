import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Modisch/core/constants/colors.dart';
import 'package:Modisch/core/database/models/outfit_model_database.dart';
import 'package:Modisch/features/model/providers/outfit_provider.dart';

/// Utility class for outfit card operations
class OutfitCardUtils {
  /// Checks if the user is hovering over the delete area (top right corner)
  static bool isHoveringOnDeleteArea(RenderBox? box, Offset globalPosition) {
    if (box == null) {
      return false;
    }
    
    final Offset localPosition = box.globalToLocal(globalPosition);
    final Size boxSize = box.size;
    
    // Check if hovering over delete button area (top right corner)
    return localPosition.dx > boxSize.width - 50 && localPosition.dy < 50;
  }

  /// Shows a confirmation dialog before deleting an outfit
  static Future<bool> showDeleteConfirmationDialog({
    required BuildContext context,
    required String outfitName,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Outfit"),
          content: Text(
            "Are you sure you want to delete '$outfitName'?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                "Cancel",
                style: TextStyle(color: AppColors.searchBarComponents),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }

  /// Deletes an outfit with an undo option
  static Future<void> deleteOutfitWithUndo({
    required BuildContext context,
    required WidgetRef ref,
    required OutfitModel outfit,
  }) async {
    final outfitToRestore = outfit;
    final outfitId = outfit.id;
    
    // Delete the outfit
    await ref.read(outfitNotifierProvider.notifier).deleteOutfit(outfitId);

    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${outfitToRestore.name} deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              ref.read(outfitNotifierProvider.notifier).updateOutfit(outfitToRestore);
            },
          ),
        ),
      );
    }
  }

  /// Helper method to build an image widget based on the path
  static Widget buildItemImage(String path, double height) {
    // Use direct path for images (don't add 'assets/images/' prefix)
    // This works for both user items (which start with '/') and dummy items (which have complete asset paths)
    return SizedBox(
      height: height,
      child: path.startsWith('/')
          ? Image.file(
              File(path),
              height: height,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 60);
              },
            )
          : Image.asset(
              path, // Use the full path as stored
              height: height,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 60);
              },
            ),
    );
  }
}