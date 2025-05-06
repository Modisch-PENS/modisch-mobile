import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:Modisch/core/constants/colors.dart';
import 'package:Modisch/core/constants/typography.dart';
import 'package:Modisch/core/database/models/wardrobe_database.dart';
import 'package:Modisch/features/wardrobe/riverpod/wardrobe_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ConfirmClothesPage extends ConsumerStatefulWidget {
  final String imagePath;
  final Function(ClothingModel) onSave;

  const ConfirmClothesPage({
    super.key,
    required this.imagePath,
    required this.onSave,
  });

  @override
  ConsumerState<ConfirmClothesPage> createState() => _ConfirmClothesPageState();
}

class _ConfirmClothesPageState extends ConsumerState<ConfirmClothesPage> {
  String _selectedCategory = 'Shirt';
  String _clothesName = '';
  final List<String> _categories = ['Shirt', 'Pants', 'Dress', 'Shoes'];
  final TextEditingController _nameController = TextEditingController();

  bool _fileExists = false;
  bool _loading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _checkFileExistence();
  }

  Future<void> _checkFileExistence() async {
    final exists = await File(widget.imagePath).exists();
    if (mounted) {
      setState(() {
        _fileExists = exists;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveClothing() async {
    if (_clothesName.isEmpty || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Generate a unique ID based on timestamp
      final id =
          '${DateTime.now().millisecondsSinceEpoch}_${const Uuid().v4().substring(0, 8)}';

      // Get application directory
      final appDir = await getApplicationDocumentsDirectory();
      final savedPath = '${appDir.path}/$id.jpg';

      // Copy the image to a permanent location
      await File(widget.imagePath).copy(savedPath);

      // Create the clothing model
      final clothing = ClothingModel(
        id: id,
        category: _selectedCategory,
        imagePath: savedPath,
        name: _clothesName,
      );

      // Save to Hive using the provider
      await ref
          .read(wardrobeNotifierProvider.notifier)
          .addClothingItem(
            id: id,
            category: _selectedCategory,
            imagePath: savedPath,
            name: _clothesName,
          );

      // Call the callback
      widget.onSave(clothing);

      // Navigate back to main page using GoRouter
      if (mounted) {
        context.goNamed('main', queryParameters: {'tab': '1'});
      }
    } catch (e) {
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => context.goNamed('wardrobe'),
        ),
        title: Text(
          'Confirm Your Clothes',
          style: AppTypography.pageTitle(context),
        ),
      ),
      body:
          _loading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.tertiary),
              )
              : !_fileExists
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Image file not found',
                      style: AppTypography.cardLabel(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.goNamed('main'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tertiary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              )
              : SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom:
                            MediaQuery.of(context).viewInsets.bottom +
                            80, // Add extra padding for the button
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(widget.imagePath),
                              height: 280,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 280,
                                  width: double.infinity,
                                  color: AppColors.disabled.withValues(alpha :0.3),
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 48,
                                    color: AppColors.disabled,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Clothes Name',
                              hintText: 'E.g., Blue Shirt, Black Pants',
                              hintStyle: AppTypography.inputTextPlaceholder(
                                context,
                              ),
                              labelStyle: AppTypography.cardLabel(context),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.disabled,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.tertiary,
                                ),
                              ),
                              prefixIcon: const Icon(Icons.label_outline),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _clothesName = value.trim();
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Category:',
                            style: AppTypography.pageTitle(context),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children:
                                _categories.map((category) {
                                  final isSelected =
                                      category == _selectedCategory;
                                  return ChoiceChip(
                                    label: Text(
                                      category,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? AppColors.secondary
                                                : AppColors.disabled,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                    selected: isSelected,
                                    backgroundColor: AppColors.background,
                                    selectedColor: AppColors.primary,
                                    elevation: isSelected ? 2 : 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    onSelected: (_) {
                                      setState(() {
                                        _selectedCategory = category;
                                      });
                                    },
                                  );
                                }).toList(),
                          ),
                          const SizedBox(
                            height: 80,
                          ), // Space for the bottom button
                        ],
                      ),
                    ),
                    // Save button positioned at the bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha :0.1),
                              blurRadius: 8,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                _clothesName.isNotEmpty && !_isSaving
                                    ? _saveClothing
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tertiary,
                              disabledBackgroundColor: AppColors.disabled
                                  .withValues(alpha :0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child:
                                _isSaving
                                    ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.save,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Save to Wardrobe',
                                          style: AppTypography.buttonLabel(
                                            context,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
