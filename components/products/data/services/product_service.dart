import 'dart:io';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class ProductService {
  static Future<void> uploadProduct({
    required String productName,
    required String description,
    required int quantity,
    required double price,
    required List<String> images,
    required String category,
  }) async {
    var imagePaths = <String>[];

    var cloudinary = CloudinaryPublic(
      Constants.cloudinaryCloudName,
      Constants.cloudinaryUploadPreset,
    );

    var resList = await cloudinary.uploadFiles(
      images.map((path) => CloudinaryFile.fromFile(path)).toList(),
    );

    for (var res in resList) {
      imagePaths.add(res.secureUrl);
    }
  }

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
