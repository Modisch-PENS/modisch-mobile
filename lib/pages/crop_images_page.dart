import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:modisch/pages/confirm_clothes_page.dart';

class CropImagesPage extends StatefulWidget {
  const CropImagesPage({Key? key}) : super(key: key);

  @override
  _CropImagesPageState createState() => _CropImagesPageState();
}

class _CropImagesPageState extends State<CropImagesPage> {
  File? _imageFile;
  CroppedFile? _croppedFile;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _cropImage() async {
    if (_imageFile == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: _imageFile!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: false, // biar default tombol crop tetap muncul
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    if (cropped != null) {
      setState(() {
        _croppedFile = cropped;
      });
    }
  }

  void _confirmCrop() {
    if (_croppedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmClothesPage(
            imagePath: _croppedFile!.path,
            onConfirm: (category, name, imagePath) {
              print('Category: $category');
              print('Name: $name');
              print('ImagePath: $imagePath');
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Image'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: const Text('Pick from Gallery'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: const Text('Pick from Camera'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _imageFile == null
                  ? const Text('No Image selected.')
                  : Image.file(_imageFile!, height: 200),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _cropImage,
                child: const Text('Crop Image'),
              ),
              const SizedBox(height: 20),
              if (_croppedFile != null) ...[
                Text('Cropped Image Preview:'),
                const SizedBox(height: 10),
                Image.file(File(_croppedFile!.path), height: 200),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _confirmCrop,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
