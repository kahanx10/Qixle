import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/admin/logic/blocs/products_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static Future<http.Response?> fetchProducts({required String token}) async {
    late http.Response res;
    try {
      res = await http.get(
        Uri.parse('${Constants.host}/admin/fetch-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': token,
        },
      );

      if (res.statusCode == 200) {
        return res;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  static Future<http.Response?> uploadProduct({
    required AddProductEvent event,
  }) async {
    try {
      var imagePaths = <String>[];

      var cloudinary = CloudinaryPublic(
        Constants.cloudinaryCloudName,
        Constants.cloudinaryUploadPreset,
      );

      var resList = await cloudinary.uploadFiles(
        event.images.map((path) => CloudinaryFile.fromFile(path)).toList(),
      );

      for (var res in resList) {
        imagePaths.add(res.secureUrl);
      }

      var res = await http.post(
        Uri.parse('${Constants.host}/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': event.token,
        },
        body: jsonEncode({
          'name': event.productName,
          'description': event.description,
          'category': event.category,
          'price': event.price,
          'quantity': event.quantity,
          'images': imagePaths,
        }),
      );

      if (res.statusCode == 200) {
        return res;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  static Future<http.Response?> deleteProduct({
    required DeleteProductEvent event,
  }) async {
    try {
      var res = await http.delete(
        Uri.parse('${Constants.host}/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': event.token,
        },
        body: jsonEncode({'id': event.productID}),
      );

      print(res.statusCode);

      if (res.statusCode == 200) {
        return res;
      }
    } catch (e) {
      rethrow;
    }
    return null;
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
