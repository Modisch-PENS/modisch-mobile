import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Modisch/core/constants/colors.dart';
import 'package:Modisch/core/constants/typography.dart';
import 'package:Modisch/core/database/models/wardrobe_database.dart';
import 'package:Modisch/features/wardrobe/riverpod/wardrobe_provider.dart';
import 'package:Modisch/features/wardrobe/widgets/user_clothing_card_utils.dart';

class UserClothingCard extends ConsumerStatefulWidget {
  final ClothingModel clothing;

  const UserClothingCard({
    super.key,
    required this.clothing,
  });

  @override
  ConsumerState<UserClothingCard> createState() => _UserClothingCardState();
}

class _UserClothingCardState extends ConsumerState<UserClothingCard> {
  bool _isLongPressed = false;
  bool _isEditing = false;
  bool _isHoveringOnDelete = false;
  late TextEditingController _nameController;
  final GlobalKey _cardKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.clothing.name);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _isEditing) {
      _saveNameChanges();
    }
  }

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isLongPressed = true;
    });
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (_isHoveringOnDelete) {
      _confirmDeleteItem();
    }
    setState(() {
      _isLongPressed = false;
      _isHoveringOnDelete = false;
    });
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    final isHovering = ClothingCardUtils.isHoveringOnDeleteArea(
      _cardKey.currentContext?.findRenderObject() as RenderBox?,
      details.globalPosition,
    );
    
    if (isHovering != _isHoveringOnDelete) {
      setState(() {
        _isHoveringOnDelete = isHovering;
      });
    }
  }

  Future<void> _confirmDeleteItem() async {
    final bool confirmDelete = await ClothingCardUtils.showDeleteConfirmationDialog(
      context: context,
      clothingName: widget.clothing.name,
    );

    if (confirmDelete) {
      await ClothingCardUtils.deleteClothingWithUndo(
        context: context,
        ref: ref,
        clothing: widget.clothing,
        onRestored: () {
          // Optional callback for when item is restored
        },
      );
    }
  }

  void _startNameEditing() {
    setState(() {
      _isEditing = true;
    });
    
    // Request focus after the state has been updated
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  void _saveNameChanges() {
    final String newName = _nameController.text.trim();
    if (newName.isNotEmpty && newName != widget.clothing.name) {
      // Create a new clothing model with updated name
      final updatedClothing = ClothingModel(
        id: widget.clothing.id,
        category: widget.clothing.category,
        imagePath: widget.clothing.imagePath,
        name: newName,
      );
      
      // Update in database
      ref.read(wardrobeNotifierProvider.notifier).updateClothingItem(updatedClothing);
    }
    
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _cardKey,
      onLongPressStart: _onLongPressStart,
      onLongPressEnd: _onLongPressEnd,
      onLongPressMoveUpdate: _onLongPressMoveUpdate,
      onDoubleTap: _startNameEditing,
      onTap: () {
        // If editing, tapping outside should save and close
        if (_isEditing) {
          _saveNameChanges();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.disabled,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                    child: Image.file(
                      File(widget.clothing.imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.disabled.withValues(alpha: 0.2),
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: AppColors.disabled,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Name / editing field
                _buildNameSection(),
              ],
            ),
            
            // Delete button that appears on long press
            if (_isLongPressed)
              _buildDeleteButton(),
            
            // Overlay for dragging state
            if (_isLongPressed)
              _buildDraggingOverlay(),
            
            // Edit indicator when in edit mode
            if (_isEditing)
              _buildEditIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameSection() {
    return _isEditing 
      ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: TextField(
            controller: _nameController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            style: AppTypography.cardLabel(context),
            textAlign: TextAlign.center,
            autofocus: true,
            onSubmitted: (_) => _saveNameChanges(),
            textInputAction: TextInputAction.done,
          ),
        )
      : Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.clothing.name,
                  textAlign: TextAlign.center,
                  style: AppTypography.cardLabel(context),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (!_isLongPressed)
                GestureDetector(
                  onTap: _startNameEditing,
                  child: const Icon(
                    Icons.edit,
                    size: 12,
                    color: AppColors.disabled,
                  ),
                ),
            ],
          ),
        );
  }

  Widget _buildDeleteButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        width: 40,
        height: 40,
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
          size: 24,
        ),
      ),
    );
  }

  Widget _buildDraggingOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildEditIndicator() {
    return const Positioned(
      top: 8,
      left: 8,
      child: CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.edit,
          size: 16,
          color: AppColors.tertiary,
        ),
      ),
    );
  }
}