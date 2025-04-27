import 'dart:io';
import '../../constants/typography.dart';
import '../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'confirm_clothes_page.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmClothesPage(imageFile: _image!),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick an Image', style: AppTypography.pageTitle(context)),
        backgroundColor: AppColors.background,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(
                  _image!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                )
                : Text('No image selected'),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
              ),
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text(
                'Pick from Gallery',
                style: AppTypography.cardLabel(context).copyWith(
                  color: AppColors.background,
                ), // Properly set text style
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
              ),
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text(
                'Take a Photo',
                style: AppTypography.cardLabel(context).copyWith(
                  color: AppColors.background,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
