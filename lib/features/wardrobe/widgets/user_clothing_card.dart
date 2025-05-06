import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Modisch/core/constants/colors.dart';
import 'package:Modisch/core/constants/typography.dart';
import 'package:Modisch/core/database/models/wardrobe_database.dart';
import 'package:Modisch/features/wardrobe/riverpod/wardrobe_provider.dart';
import 'package:path_provider/path_provider.dart';

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
      
      // Check if the user is dragging to the delete button area (top right corner)
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
          title: const Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete '${widget.clothing.name}'?",
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

    // Store the clothing model and make a backup of the file before deletion
    final clothingToRestore = widget.clothing;
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

    if (confirmDelete) {
      // Get the notifier reference BEFORE the widget might be disposed
      final notifier = ref.read(wardrobeNotifierProvider.notifier);

      // Delete the item
      await notifier.deleteClothingItem(clothingToRestore.id);

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${clothingToRestore.name} deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Use the cached notifier instead of ref
                () async {
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
                } catch (e) {
                debugPrint('Error restoring item: $e');
                } finally {
                // Clean up the temporary file
                if (tempBackupFile != null && await tempBackupFile.exists()) {
                await tempBackupFile.delete();
                }
                }
              }();
              },
            ),
          ),
        );
      }
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
      
      // Update in Hive database
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
                          color: AppColors.disabled.withValues(alpha :0.2),
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
                _isEditing 
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
                      ),
              ],
            ),
            
            // Delete button that appears on long press
            if (_isLongPressed)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 40,
                  height: 40,
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
                    size: 24,
                  ),
                ),
              ),
            
            // Overlay for dragging state
            if (_isLongPressed)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha :0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            
            // Edit indicator when in edit mode
            if (_isEditing)
              const Positioned(
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
              ),
          ],
        ),
      ),
    );
  }
}