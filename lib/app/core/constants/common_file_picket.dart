import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class CommonFilePicker {
  static final ImagePicker _imagePicker = ImagePicker();

  /// isFile = true  → pick any file (pdf, doc, etc.)
  /// isFile = false → pick image only
  ///
  /// useCamera only applies for image picking
  static Future<File?> pick({
    required bool isFile,
    bool useCamera = false,
  }) async {
    try {
      // 📄 Pick any file
      if (isFile) {
        final result = await FilePicker.platform.pickFiles(type: FileType.any);

        if (result != null && result.files.single.path != null) {
          return File(result.files.single.path!);
        }
        return null;
      }

      // 🖼 Pick image only
      final XFile? image = await _imagePicker.pickImage(
        source: useCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
