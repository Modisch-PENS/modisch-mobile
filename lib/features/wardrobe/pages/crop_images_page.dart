import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:Modisch/core/constants/colors.dart';

class CropImagePage extends StatefulWidget {
  final ImageSource source;

  const CropImagePage({super.key, required this.source});

  @override
  State<CropImagePage> createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pickAndCropImage();
  }

  Future<void> _pickAndCropImage() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(
        source: widget.source,
        imageQuality: 80,
      );

      if (pickedImage == null) {
        if (mounted) {
          context.goNamed('main');
        }
        return;
      }

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: AppColors.secondary,
            hideBottomControls: false,
            lockAspectRatio: true,
            initAspectRatio: CropAspectRatioPreset.square,
            showCropGrid: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            aspectRatioPickerButtonHidden: true,
          ),
        ],
      );

      if (!mounted) return;

      if (croppedFile != null) {
        // Use GoRouter to navigate to the confirm page with the image path
        final encodedPath = Uri.encodeComponent(croppedFile.path);
        context.goNamed('confirm_clothes', pathParameters: {'imagePath': encodedPath});
      } else {
        context.goNamed('main');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error: ${e.toString()}';
        });
        // Show error for 2 seconds then navigate back
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.goNamed('main');
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _errorMessage != null
            ? Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )
            : const CircularProgressIndicator(
                color: AppColors.tertiary,
              ),
      ),
    );
  }
}