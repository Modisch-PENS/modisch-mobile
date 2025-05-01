import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modisch/core/database/clothing_model.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/wardrobe_service.dart';

class AddClothingPage extends StatefulWidget {
  final File imageFile;

  const AddClothingPage({super.key, required this.imageFile});

  @override
  State<AddClothingPage> createState() => _AddClothingPageState();
}

class _AddClothingPageState extends State<AddClothingPage> {
  File? _selectedImage;
  final _categoryController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final WardrobeService _wardrobeService = WardrobeService();

  // Pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _selectedImage = widget.imageFile;
  }

  // Save image to Hive
  Future<void> _saveClothing() async {
    if (_selectedImage == null || _categoryController.text.isEmpty) return;

    final clothing = ClothingModel(
      id: DateTime.now().toString(),
      category: _categoryController.text,
      imagePath: _selectedImage!.path,
    );

    await _wardrobeService.addClothing(clothing);
    Navigator.pop(context); // Go back to the previous screen
  }

  Future<void> _requestPermissions() async {
    final status = await [
      Permission.camera,
      Permission.photos,
      Permission.storage,
    ].request();

    // Optional: handle denial
    if (status.values.any((element) => element.isDenied)) {
      // Show a dialog or guide user to settings
      print('Some permissions were denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Clothing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveClothing,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 16),
            _selectedImage != null
                ? Image.file(
              _selectedImage!,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            )
                : const Text('No image selected'),
            const SizedBox(height: 24),
            if (_selectedImage == null) ...[
              ElevatedButton.icon(
              icon: const Icon(Icons.photo),
              label: const Text('Pick from Gallery'),
              onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ],
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo),
              label: const Text('Pick from Gallery'),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take a Photo'),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }
}
