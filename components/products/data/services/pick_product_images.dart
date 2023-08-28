import 'dart:io';

import 'package:file_picker/file_picker.dart';

class PickImagesService {
  static Future<List<File>> pickProductImages() async {
    List<File> images = [];

    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (files != null && files.files.isNotEmpty) {
        for (var file in files.files) {
          images.add(File(file.path!));
        }
      }
    } catch (e) {
      print('Error picking images$e');
    }
    return images;
  }
}
