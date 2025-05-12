import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Modisch/core/database/models/wardrobe_database.dart';
import 'package:Modisch/features/wardrobe/riverpod/wardrobe_provider.dart';

/// Utility class for clothing card operations
class ClothingCardUtils {
  /// Checks if the user is hovering over the delete area (top right corner)
  static bool isHoveringOnDeleteArea(RenderBox? box, Offset globalPosition) {
    if (box == null) {
      return false;
    }
    
    final Offset localPosition = box.globalToLocal(globalPosition);
    final Size boxSize = box.size;
    
    // Check if hovering over the top right 50x50 px area
    return localPosition.dx > boxSize.width - 50 && localPosition.dy < 50;
  }

  /// Shows a confirmation dialog before deleting an item
  static Future<bool> showDeleteConfirmationDialog({
    required BuildContext context,
    required String clothingName,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete '$clothingName'?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
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

  /// Deletes a clothing item with an undo option
  static Future<void> deleteClothingWithUndo({
    required BuildContext context,
    required WidgetRef ref,
    required ClothingModel clothing,
    VoidCallback? onRestored,
  }) async {
    // Store the clothing model and make a backup of the file before deletion
    final clothingToRestore = clothing;
    final originalFilePath = clothingToRestore.imagePath;
    File? tempBackupFile;

    // Create temporary backup of image file before deletion
    try {
      final originalFile = File(originalFilePath);
      if (await originalFile.exists()) {
        // Create a temporary file with the same extension
        final tempPath = '${(await getTemporaryDirectory()).path}/${clothingToRestore.id}_backup.jpg';
        tempBackupFile = await originalFile.copy(tempPath);
        debugPrint('Image backed up to: $tempPath');
      }
    } catch (e) {
      debugPrint('Error backing up image: $e');
    }

    // Get the notifier reference before any potential widget disposal
    final notifier = ref.read(wardrobeNotifierProvider.notifier);

    // Delete the item
    await notifier.deleteClothingItem(clothingToRestore.id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${clothingToRestore.name} deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              try {
                // If we have a backup file, restore it first
                if (tempBackupFile != null && await tempBackupFile.exists()) {
                  final destinationFile = File(originalFilePath);
                  // Ensure parent directory exists
                  await destinationFile.parent.create(recursive: true);
                  // Copy the backup back to the original location
                  await tempBackupFile.copy(originalFilePath);
                  debugPrint('Image restored to: $originalFilePath');
                }

                // Now restore the database entry
                await notifier.addClothingItem(
                  id: clothingToRestore.id,
                  category: clothingToRestore.category,
                  imagePath: clothingToRestore.imagePath,
                  name: clothingToRestore.name,
                );
                debugPrint('Item restored: ${clothingToRestore.name}');
                
                if (onRestored != null) {
                  onRestored();
                }
              } catch (e) {
                debugPrint('Error restoring item: $e');
              } finally {
                // Clean up the temporary file
                if (tempBackupFile != null && await tempBackupFile.exists()) {
                  await tempBackupFile.delete();
                }
              }
            },
          ),
        ),
      );
    }
  }
}