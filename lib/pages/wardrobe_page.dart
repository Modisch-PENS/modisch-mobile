import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:modisch/constants/typography.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modisch/pages/confirm_clothes_page.dart';
import 'package:modisch/pages/crop_images_page.dart';

// Model class for storing a clothing item
class ClothesItem {
  final String path;
  final String name;

  ClothesItem({required this.path, required this.name});

  factory ClothesItem.fromJson(Map<String, dynamic> json) {
    return ClothesItem(
      path: json['path'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'path': path,
        'name': name,
      };
}

class WardrobePage extends StatefulWidget {
  const WardrobePage({Key? key}) : super(key: key);

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  final double boxWidth = 160;
  final double boxHeight = 184;
  final List<String> _categories = ['Shirt', 'Pants', 'Dress', 'Shoes'];
  int _currentTabIndex = 0;
  bool _isCameraOrGalleryVisible = false;

  late Map<String, List<ClothesItem>> _categoryItems;

  @override
  void initState() {
    super.initState();
    _categoryItems = {for (var c in _categories) c: []};
    _loadItems();
  }

  Future<void> _pickImage(ImageSource source) async {
    // 1) Pick & crop
    final croppedImagePath = await Navigator.push<String?>( 
      context,
      MaterialPageRoute(builder: (_) => CropImagePage(source: source)),
    );
    if (croppedImagePath == null) return;

    // 2) Open confirm page with onSave callback
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmClothesPage(
          imagePath: croppedImagePath,
          onSave: (selectedCategory, clothesName) async {
            // Copy file to app directory
            final dir = await getApplicationDocumentsDirectory();
            final savedPath =
                '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
            try {
              await File(croppedImagePath).copy(savedPath);

              // Update local state
              setState(() {
                _categoryItems[selectedCategory]!
                    .add(ClothesItem(path: savedPath, name: clothesName));
              });

              // Save to SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              final key = 'items_${selectedCategory}';  // Fixed string interpolation
              final list = _categoryItems[selectedCategory]!;
              final jsonList =
                  list.map((item) => jsonEncode(item.toJson())).toList();
              await prefs.setStringList(key, jsonList);
            } catch (e) {
              // Handle file copy error
              print("Error copying file: $e");
            }
          },
        ),
      ),
    );
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var category in _categories) {
        final jsonList = prefs.getStringList('items_${category}') ?? [];
        _categoryItems[category] = jsonList
            .map((j) => ClothesItem.fromJson(jsonDecode(j)))
            .toList();
      }
    });
  }

  void _toggleCameraGallery() {
    setState(() => _isCameraOrGalleryVisible = !_isCameraOrGalleryVisible);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories.length,
      initialIndex: _currentTabIndex,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 1,
          title: Text('Wardrobe', style: AppTypography.pageTitle),
          bottom: TabBar(
            indicatorColor: AppColors.tertiary,
            labelColor: AppColors.secondary,
            unselectedLabelColor: AppColors.disabled,
            labelStyle: AppTypography.buttonLabel,
            unselectedLabelStyle: AppTypography.buttonLabel,
            onTap: (i) => setState(() => _currentTabIndex = i),
            tabs: _categories.map((c) => Tab(text: c)).toList(),
          ),
        ),
        body: TabBarView(
          children: _categories.map((category) {
            final items = _categoryItems[category]!;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (ctx, constraints) {
                  final crossCount =
                      (constraints.maxWidth / (boxWidth + 16)).floor().clamp(1, 4);
                  return GridView.builder(
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: boxWidth / boxHeight,
                    ),
                    itemCount: items.length,
                    itemBuilder: (_, idx) {
                      final item = items[idx];
                      return Container(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                child: Image.file(
                                  File(item.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                item.name,
                                textAlign: TextAlign.center,
                                style: AppTypography.cardLabel,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }).toList(),
        ),
        floatingActionButton: _isCameraOrGalleryVisible
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'gallery',
                    backgroundColor: AppColors.tertiary,
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: const Icon(Icons.photo_library),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: 'camera',
                    backgroundColor: AppColors.tertiary,
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: const Icon(Icons.camera_alt),
                  ),
                ],
              )
            : FloatingActionButton(
                backgroundColor: AppColors.tertiary,
                onPressed: _toggleCameraGallery,
                child: const Icon(Icons.add_a_photo),
              ),
      ),
    );
  }
}
