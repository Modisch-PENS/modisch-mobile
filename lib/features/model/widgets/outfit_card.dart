import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Modisch/core/constants/colors.dart';
import 'package:Modisch/core/database/models/outfit_model_database.dart';
import 'package:Modisch/features/model/providers/outfit_provider.dart';

class OutfitCard extends ConsumerStatefulWidget {
  final OutfitModel outfit;
  final VoidCallback onEdit;

  const OutfitCard({
    super.key,
    required this.outfit,
    required this.onEdit,
  });

  @override
  ConsumerState<OutfitCard> createState() => _OutfitCardState();
}

class _OutfitCardState extends ConsumerState<OutfitCard> {
  bool _isLongPressed = false;
  final GlobalKey _cardKey = GlobalKey();
  bool _isHoveringOnDelete = false;

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isLongPressed = true;
    });
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (_isHoveringOnDelete) {
      _confirmDelete();
    }
    setState(() {
      _isLongPressed = false;
      _isHoveringOnDelete = false;
    });
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    final RenderBox? box = _cardKey.currentContext?.findRenderObject() as RenderBox?;

    if (box != null) {
      final Offset localPosition = box.globalToLocal(details.globalPosition);
      final Size boxSize = box.size;

      // Check if hovering over delete button area (top right corner)
      final bool isHovering = localPosition.dx > boxSize.width - 50 && localPosition.dy < 50;

      if (isHovering != _isHoveringOnDelete) {
        setState(() {
          _isHoveringOnDelete = isHovering;
        });
      }
    }
  }

  Future<void> _confirmDelete() async {
    final bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Outfit"),
          content: Text(
            "Are you sure you want to delete '${widget.outfit.name}'?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel",style: TextStyle(color: AppColors.searchBarComponents),),
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

    final outfitToRestore = widget.outfit;

    if (confirmDelete) {
      final outfitId = widget.outfit.id;
      await ref.read(outfitNotifierProvider.notifier).deleteOutfit(outfitId);

      if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    // Helper function to check if an item exists
    bool isValid(String? img) => img != null && img.isNotEmpty;

    return GestureDetector(
      key: _cardKey,
      onLongPressStart: _onLongPressStart,
      onLongPressEnd: _onLongPressEnd,
      onLongPressMoveUpdate: _onLongPressMoveUpdate,
      onTap: () {
        if (_isLongPressed) {
          setState(() => _isLongPressed = false);
          return;
        }
        widget.onEdit();
      },
      child: Stack(
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: 180,
              minWidth: MediaQuery.of(context).size.width * 0.4,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.disabled,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.outfit.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 10),
                if (isValid(widget.outfit.shirt))
                  _buildItemImage(widget.outfit.shirt!, 60),
                if (isValid(widget.outfit.pants))
                  _buildItemImage(widget.outfit.pants!, 60),
                if (isValid(widget.outfit.dress))
                  _buildItemImage(widget.outfit.dress!, 60),
                if (isValid(widget.outfit.shoes))
                  _buildItemImage(widget.outfit.shoes!, 60),
              ],
            ),
          ),

          // Delete button that appears on long press
          if (_isLongPressed)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _isHoveringOnDelete
                      ? Colors.red
                      : AppColors.primary.withValues(alpha :0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha :0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.delete,
                  color: _isHoveringOnDelete
                      ? Colors.white
                      : AppColors.secondary,
                  size: 20,
                ),
              ),
            ),

          // Overlay for dragging state
          if (_isLongPressed)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha :0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to build an image widget based on the path
  Widget _buildItemImage(String path, double height) {
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