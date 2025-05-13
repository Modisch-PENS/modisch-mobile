import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Modisch/core/constants/colors.dart';
import 'package:Modisch/core/database/models/outfit_model_database.dart';
import 'package:Modisch/features/model/providers/outfit_provider.dart';
import 'package:Modisch/features/model/widgets/outfit_card_utils.dart';

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
  bool _isHoveringOnDelete = false;
  final GlobalKey _cardKey = GlobalKey();

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isLongPressed = true;
    });
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (_isHoveringOnDelete) {
      _confirmDeleteOutfit();
    }
    setState(() {
      _isLongPressed = false;
      _isHoveringOnDelete = false;
    });
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    final isHovering = OutfitCardUtils.isHoveringOnDeleteArea(
      _cardKey.currentContext?.findRenderObject() as RenderBox?,
      details.globalPosition,
    );
    
    if (isHovering != _isHoveringOnDelete) {
      setState(() {
        _isHoveringOnDelete = isHovering;
      });
    }
  }

  Future<void> _confirmDeleteOutfit() async {
    final bool confirmDelete = await OutfitCardUtils.showDeleteConfirmationDialog(
      context: context,
      outfitName: widget.outfit.name,
    );

    if (confirmDelete) {
      await OutfitCardUtils.deleteOutfitWithUndo(
        context: context,
        ref: ref,
        outfit: widget.outfit,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          _buildOutfitContainer(),
          
          // Delete button that appears on long press
          if (_isLongPressed)
            _buildDeleteButton(),

          // Overlay for dragging state
          if (_isLongPressed)
            _buildDraggingOverlay(),
        ],
      ),
    );
  }

  Widget _buildOutfitContainer() {
    return Container(
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
          _buildOutfitItems(),
        ],
      ),
    );
  }

  Widget _buildOutfitItems() {
    // Helper function to check if an item exists
    bool isValid(String? img) => img != null && img.isNotEmpty;
    
    return Column(
      children: [
        if (isValid(widget.outfit.shirt))
          OutfitCardUtils.buildItemImage(widget.outfit.shirt!, 60),
        if (isValid(widget.outfit.pants))
          OutfitCardUtils.buildItemImage(widget.outfit.pants!, 60),
        if (isValid(widget.outfit.dress))
          OutfitCardUtils.buildItemImage(widget.outfit.dress!, 60),
        if (isValid(widget.outfit.shoes))
          OutfitCardUtils.buildItemImage(widget.outfit.shoes!, 60),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _isHoveringOnDelete
              ? Colors.red
              : AppColors.primary.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
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
    );
  }

  Widget _buildDraggingOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}