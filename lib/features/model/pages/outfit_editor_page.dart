import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/typography.dart';
import 'package:modisch/core/database/models/outfit_model_database.dart';
import 'package:modisch/features/main/riverpod/main_page_provider.dart';
import 'package:modisch/features/model/providers/outfit_provider.dart';
import 'package:modisch/features/model/widgets/item_category_screen.dart';
import 'package:modisch/features/model/widgets/outfit_preview.dart';
import 'package:modisch/features/model/widgets/top_tab_bar.dart';

class OutfitEditorPage extends ConsumerStatefulWidget {
  final String? outfitId;

  const OutfitEditorPage({super.key, this.outfitId});

  @override
  ConsumerState<OutfitEditorPage> createState() => _OutfitEditorPageState();
}

class _OutfitEditorPageState extends ConsumerState<OutfitEditorPage> {
  int _currentTabIndex = 0;
  late PageController _pageController;
  final List<String> _categories = ['Shirt', 'Pants', 'Dress', 'Shoes'];
  bool _isEditing = false;
  bool _isEditingTitle = false;
  final TextEditingController _titleController = TextEditingController(
    text: "New Outfit",
  );
  final FocusNode _titleFocusNode = FocusNode();

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
        // Set the title controller with the outfit name
        setState(() {
          _titleController.text = outfit.name;
        });
      }
    } else {
      // Creating new outfit
      ref.read(outfitEditorNotifierProvider.notifier).reset();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _titleFocusNode.dispose();
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

  void _navigateToModelTab() {
    // Set the MainPageNotifier to show the model tab
    ref
        .read(mainPageNotifierProvider.notifier)
        .changePageToTab(MainPageTab.model);
    // Navigate to main page, replacing the current screen
    context.goNamed('main', queryParameters: {'tab': '2'});
  }

  void _discardChanges() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
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
                  _navigateToModelTab();
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

  Future<void> _saveOutfit() async {
    final editorState = ref.read(outfitEditorNotifierProvider);
    final outfitName = _titleController.text.trim();

    // Check if outfit has a name
    if (outfitName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an outfit name'),
          backgroundColor: Colors.red,
        ),
      );
      _startTitleEditing();
      return;
    }

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

    final outfitNotifier = ref.read(outfitNotifierProvider.notifier);

    try {
      if (_isEditing && widget.outfitId != null) {
        // Update existing outfit
        final outfit = editorState.copyWith(
          id: widget.outfitId!,
          name: outfitName,
        );
        await outfitNotifier.updateOutfit(outfit);
      } else {
        // Add new outfit
        await outfitNotifier.addOutfit(
          name: outfitName,
          shirt: editorState.shirt,
          pants: editorState.pants,
          dress: editorState.dress,
          shoes: editorState.shoes,
        );
      }

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_isEditing ? 'Updated' : 'Saved'}: $outfitName'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to model tab
        _navigateToModelTab();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving outfit: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startTitleEditing() {
    setState(() {
      _isEditingTitle = true;
    });

    // Focus on the text field after state update
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _titleFocusNode.requestFocus();
      }
    });
  }

  void _finishTitleEditing() {
    setState(() {
      _isEditingTitle = false;
    });
    _titleFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Tap outside to finish editing title and dismiss keyboard
      onTap: () {
        if (_isEditingTitle) {
          _finishTitleEditing();
        }
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        // Handle back button press
        onWillPop: () async {
          _discardChanges();
          return false; // Prevent default back navigation
        },
        child: Scaffold(
          // Important: Set this to false to handle keyboard ourselves
          resizeToAvoidBottomInset: false,
          backgroundColor:AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            centerTitle: true,
            title: _isEditingTitle
                ? _buildTitleEditField()
                : Text(
                    _titleController.text,
                    style: AppTypography.pageTitle(context),
                  ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
              onPressed: _discardChanges,
            ),
            actions: [
              if (!_isEditingTitle)
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.secondary),
                  onPressed: _startTitleEditing,
                ),
            ],
          ),
          body: Stack(
            children: [
              Column(
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
                      children:
                          _categories.map((category) {
                            return ItemCategoryScreen(category: category);
                          }).toList(),
                    ),
                  ),
                ],
              ),
              // Overlay for title editing when keyboard is shown
              if (_isEditingTitle)
                _buildTitleEditOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleEditField() {
    return SizedBox(
      height: 40,
      width: 200,
      child: TextField(
        controller: _titleController,
        focusNode: _titleFocusNode,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.secondary,
              width: 2,
            ),
          ),
        ),
        style: AppTypography.inputTextPlaceholder(context),
        textAlign: TextAlign.center,
        onSubmitted: (_) => _finishTitleEditing(),
        // Add text editing complete callback for keyboard done button
        textInputAction: TextInputAction.done,
        onEditingComplete: _finishTitleEditing,
      ),
    );
  }

  Widget _buildTitleEditOverlay() {
    // This overlay appears when editing the title with keyboard open
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: MediaQuery.of(context).viewInsets.bottom,
      child: IgnorePointer(
        // This makes the overlay non-interactive, allowing clicks to pass through
        child: Container(
          color: Colors.black.withOpacity(0.1),
        ),
      ),
    );
  }
}