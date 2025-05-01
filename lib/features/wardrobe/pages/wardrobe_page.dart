import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modisch/core/database/clothing_model.dart';
import 'add_clothing_page.dart';
import '../widgets/wardrobe_service.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  final WardrobeService _wardrobeService = WardrobeService();
  late List<ClothingModel> _clothingItems = [];

  @override
  void initState() {
    super.initState();
    _loadClothingItems();
  }

  Future<void> _loadClothingItems() async {
    final items = _wardrobeService.getAllClothing();
    setState(() {
      _clothingItems = items;
    });
  }

  Future<void> _showImageSourceOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => _pickAndCropImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Gallery'),
              onTap: () => _pickAndCropImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndCropImage(ImageSource source) async {
    Navigator.pop(context); // Close bottom sheet
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      try {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
        );

        if (croppedFile != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddClothingPage(
                imageFile: File(croppedFile.path),
              ),
            ),
          );
        }
      } catch (e) {
        print('Error cropping image: $e');
        // Fallback to using the uncropped image
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddClothingPage(
              imageFile: File(pickedFile.path),
            ),
          ),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobe'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _clothingItems.isEmpty
                ? const Center(child: Text('No items in wardrobe'))
                : ListView.builder(
              itemCount: _clothingItems.length,
              itemBuilder: (context, index) {
                final clothing = _clothingItems[index];
                return ListTile(
                  title: Text(clothing.category),
                  subtitle: Text(clothing.imagePath),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await _wardrobeService.deleteClothing(clothing);
                      _loadClothingItems();
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _showImageSourceOptions,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Add Clothing'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showImageSourceOptions,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}