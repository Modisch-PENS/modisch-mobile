import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:modisch/core/database/clothing_model.dart';
import 'wardrobe_service.dart';
import 'dart:convert';
import 'dart:typed_data';

class AddClothingPage extends StatefulWidget {
  const AddClothingPage({super.key});

  @override
  State<AddClothingPage> createState() => _AddClothingPageState();
}

class _AddClothingPageState extends State<AddClothingPage> {
  File? _selectedImage;
  final _categoryController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final WardrobeService _wardrobeService = WardrobeService();

  // Pick image from gallery or camera

  Future<void> _removeBackground(File imageFile) async {
    final String apiKey = 'YOUR_REMOVE_BG_API_KEY';
    final Uri url = Uri.parse('https://api.remove.bg/v1.0/removebg');

    final request = http.MultipartRequest('POST', url)
      ..headers['X-Api-Key'] = apiKey
      ..files.add(await http.MultipartFile.fromPath('image_file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final bytes = await response.stream.toBytes();
      final resultImage = File('${imageFile.path}_no_bg.png');
      await resultImage.writeAsBytes(bytes);

      setState(() {
        _selectedImage = resultImage;
      });
    } else {
      // Handle error
      print('Failed to remove background: ${response.statusCode}');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      // Call the remove.bg API
      await _removeBackground(_selectedImage!);
    }
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
