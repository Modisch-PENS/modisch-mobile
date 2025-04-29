import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:modisch/constants/typography.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modisch/pages/confirm_clothes_page.dart';
import 'package:modisch/pages/crop_images_page.dart'; // <- Tambahkan ini

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

  Map<String, List<String>> _categoryImages = {
    'Shirt': [],
    'Pants': [],
    'Dress': [],
    'Shoes': [],
  };

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _pickImage(ImageSource source) async {
    final String? croppedImagePath = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropImagePage(source: source),
      ),
    );

    if (croppedImagePath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmClothesPage(
            imagePath: croppedImagePath,
            onCategorySelected: (selectedCategory, clothesName) async {
              final directory = await getApplicationDocumentsDirectory();
              final path = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
              File imageFile = File(croppedImagePath);
              await imageFile.copy(path);

              setState(() {
                _categoryImages[selectedCategory]?.add(path);
              });

              _saveImages();
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
  }

  Future<void> _saveImages() async {
    final prefs = await SharedPreferences.getInstance();
    for (var category in _categories) {
      await prefs.setStringList('images_$category', _categoryImages[category]!);
    }
  }

  Future<void> _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    for (var category in _categories) {
      _categoryImages[category] = prefs.getStringList('images_$category') ?? [];
    }
    setState(() {});
  }

  void _toggleCameraGallery() {
    setState(() {
      _isCameraOrGalleryVisible = !_isCameraOrGalleryVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });
            },
            tabs: const [
              Tab(text: 'Shirt'),
              Tab(text: 'Pants'),
              Tab(text: 'Dress'),
              Tab(text: 'Shoes'),
            ],
          ),
        ),
        body: TabBarView(
          children: List.generate(4, (tabIndex) {
            final category = _categories[tabIndex];
            final images = _categoryImages[category]!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = (constraints.maxWidth / (boxWidth + 16)).floor();
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: boxWidth / boxHeight,
                    ),
                    itemCount: images.length,
                    itemBuilder: (_, index) {
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
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.file(
                                  File(images[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              child: Text(
                                '$category ${index + 1}',
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
          }),
        ),
        floatingActionButton: _isCameraOrGalleryVisible
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    backgroundColor: AppColors.tertiary,
                    heroTag: null,
                    child: const Icon(Icons.photo_library),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    backgroundColor: AppColors.tertiary,
                    heroTag: null,
                    child: const Icon(Icons.camera_alt),
                  ),
                ],
              )
            : FloatingActionButton(
                onPressed: _toggleCameraGallery,
                backgroundColor: AppColors.tertiary,
                child: const Icon(Icons.add_a_photo),
              ),
      ),
    );
  }
}
