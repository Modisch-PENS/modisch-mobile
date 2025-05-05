import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/typography.dart';
import 'package:modisch/core/database/models/outfit_model_database.dart';
import 'package:modisch/features/model/providers/outfit_provider.dart';
import 'package:modisch/features/model/widgets/item_category_screen.dart';
import 'package:modisch/features/model/widgets/outfit_preview.dart';
import 'package:modisch/features/model/widgets/top_tab_bar.dart';

class OutfitEditorPage extends ConsumerStatefulWidget {
  final String? outfitId;

  const OutfitEditorPage({
    super.key,
    this.outfitId,
  });

  @override
  ConsumerState<OutfitEditorPage> createState() => _OutfitEditorPageState();
}

class _OutfitEditorPageState extends ConsumerState<OutfitEditorPage> {
  int _currentTabIndex = 0;
  late PageController _pageController;
  final List<String> _categories = ['Shirt', 'Pants', 'Dress', 'Shoes'];
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentTabIndex);
    _loadOutfit();
  }
  
  Future<void> _loadOutfit() async {
    if (widget.outfitId != null) {
      // Edit existing outfit
      setState(() => _isEditing = true);
      
      // Use outfit notifier to get outfit by ID
      final outfitsState = await ref.read(outfitNotifierProvider.future);
      final outfit = outfitsState.firstWhere(
        (o) => o.id == widget.outfitId,
        orElse: () => OutfitModel.empty(),
      );
      
      // Load into editor
      if (outfit.id.isNotEmpty) {
        ref.read(outfitEditorNotifierProvider.notifier).loadOutfit(outfit);
      }
    } else {
      // Creating new outfit
      ref.read(outfitEditorNotifierProvider.notifier).reset();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentTabIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  void _discardChanges() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard Changes'),
        content: const Text('Do you want to discard unsaved changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            child: const Text(
              'Discard',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
  
  void _saveOutfit() {
    final editorState = ref.read(outfitEditorNotifierProvider);
    
    // Check if outfit has any items
    if (!ref.read(outfitEditorNotifierProvider.notifier).isReadyToSave) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one item to your outfit'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Show name input dialog
    final controller = TextEditingController(
      text: _isEditing ? editorState.name : '',
    );
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_isEditing ? 'Update Outfit' : 'Save Outfit'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter outfit name",
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter outfit name'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              final outfitNotifier = ref.read(outfitNotifierProvider.notifier);
              
              if (_isEditing && widget.outfitId != null) {
                // Update existing outfit
                final outfit = editorState.copyWith(
                  id: widget.outfitId!,
                  name: name,
                );
                await outfitNotifier.updateOutfit(outfit);
              } else {
                // Add new outfit
                await outfitNotifier.addOutfit(
                  name: name,
                  shirt: editorState.shirt,
                  pants: editorState.pants,
                  dress: editorState.dress,
                  shoes: editorState.shoes,
                );
              }
              
              if (mounted) {
                Navigator.pop(ctx);
                context.goNamed('main', queryParameters: {'tab': '2'});
              }
            },
            child: const Text('Save', style: TextStyle(color: AppColors.tertiary),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _isEditing ? 'Edit Outfit' : 'Create Outfit',
          style: AppTypography.pageTitle(context),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: _discardChanges,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const OutfitPreview(),
          const SizedBox(height: 16),
          // Save Button
          SizedBox(
            width: 268,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: _saveOutfit,
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Tab Bar
          TopTabBar(
            currentIndex: _currentTabIndex,
            onTabSelected: _onTabSelected,
            tabs: _categories,
          ),
          const SizedBox(height: 10),
          // PageView for categories
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
              children: _categories.map((category) {
                return ItemCategoryScreen(category: category);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}