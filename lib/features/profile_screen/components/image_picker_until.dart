import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  // Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Reduce quality to save bandwidth
      );

      if (pickedImage != null) {
        return File(pickedImage.path);
      }

      return null;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  // Pick image from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70, // Reduce quality to save bandwidth
      );

      if (pickedImage != null) {
        return File(pickedImage.path);
      }

      return null;
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return null;
    }
  }

  // Show image picker dialog
  static Future<File?> showImagePickerDialog(BuildContext context) async {
    File? pickedImage;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          'Chọn ảnh từ',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.deepOrange),
              title: const Text('Thư viện', style: TextStyle(color: Colors.white)),
              onTap: () async {
                final image = await pickImageFromGallery();
                pickedImage = image;
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.deepOrange),
              title: const Text('Máy ảnh', style: TextStyle(color: Colors.white)),
              onTap: () async {
                final image = await pickImageFromCamera();
                pickedImage = image;
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy', style: TextStyle(color: Colors.deepOrange)),
          ),
        ],
      ),
    );

    return pickedImage;
  }
}