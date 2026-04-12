import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Picks an image from the specified source (camera or gallery),
  /// crops it using the native image_cropper, and returns the final File.
  static Future<File?> pickAndCropImage({
    required BuildContext context,
    required ImageSource source,
  }) async {
    try {
      // 1. Image Selection
      // Compress image if size is large (using imageQuality)
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, 
      );

      // Handle null image selection (user cancelled picker)
      if (pickedFile == null) return null;

      // 2. Image Cropping 
      // Use image_cropper package to allow zoom, rotate, and square crop
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Square crop for profile pic
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Picture',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true, // Fixed for square/circular aspect
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Crop Profile Picture',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      // Handle crop cancel case
      if (croppedFile == null) return null;

      // Return final cropped image file
      return File(croppedFile.path);
    } catch (e) {
      // Avoid crashes
      debugPrint('[DEBUG] ImageService Error: $e');
      return null;
    }
  }
}
