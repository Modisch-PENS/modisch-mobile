import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:modisch/constants/colors.dart';

class CropImagePage extends StatefulWidget {
  final ImageSource source;

  const CropImagePage({super.key, required this.source});

  @override
  State<CropImagePage> createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  @override
  void initState() {
    super.initState();
    _pickAndCropImage();
  }

  Future<void> _pickAndCropImage() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: widget.source);

      if (pickedImage == null) {
        if (mounted) Navigator.pop(context);
        return;
      }

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: Colors.transparent,
            hideBottomControls: true,
            lockAspectRatio: false,
            initAspectRatio: CropAspectRatioPreset.square,
            showCropGrid: true,
          ),
        ],
      );

      if (!mounted) return;

      if (croppedFile != null) {
        Navigator.pop(context, croppedFile.path);
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
