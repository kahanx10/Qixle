// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/data/services/message_service.dart';
import 'package:amazon_clone/components/admin/data/models/earnings_model.dart';
import 'package:amazon_clone/components/admin/logic/blocs/products_bloc.dart';
import 'package:amazon_clone/components/authentication/data/services/auth_token_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminService {
  static Future<List<Earning>> getAnalytics(
    BuildContext context,
  ) async {
    var allEarnings = <Earning>[];
    try {
      var token = await AuthTokenService.getToken();

      if (token == null) {
        MessageService.showSnackBar(
          context,
          message: 'Session expired, please log in again to proceed!',
        );

        throw Exception('Couldn\'nt get analytics, please try again!');
      }

      var res = await http.get(
        Uri.parse('${Constants.host}/admin/analytics'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': token,
        },
      );

      if (res.statusCode != 200) {
        throw Exception('Couldn\'nt get analytics, please try again!');
      }

      var earningsList = jsonDecode(res.body);

      for (var earnings in earningsList) {
        allEarnings.add(Earning.fromMap(earnings));
      }
    } catch (e) {
      MessageService.showSnackBar(context, message: e.toString());
    }

    return allEarnings;
  }

  static Future<int> changeOrderStatus(
    BuildContext context, {
    required String orderId,
    required int status,
  }) async {
    var token = await AuthTokenService.getToken();

    if (token == null) {
      MessageService.showSnackBar(
        context,
        message: 'Session expired, please log in again to proceed!',
      );

      throw Exception('Couldn\'nt mark it as done, please try again!');
    }

    var res = await http.post(
      Uri.parse('${Constants.host}/admin/change-order-status'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'authToken': token,
      },
      body: jsonEncode({
        'orderId': orderId,
        'status': status,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Couldn\'nt mark it as done, please try again!');
    }

    return jsonDecode(res.body);
  }

  static Future<http.Response?> fetchProducts() async {
    late http.Response res;
    try {
      var token = await AuthTokenService.getToken();

      if (token == null) {
        return null;
      }

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
      print(res.statusCode);
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
    required String productId,
    required bool isAvailable,
  }) async {
    try {
      var token = await AuthTokenService.getToken();

      if (token == null) {
        return null;
      }

      var res = await http.delete(
        Uri.parse('${Constants.host}/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authToken': token,
        },
        body: jsonEncode({'productId': productId, 'isAvailable': isAvailable}),
      );

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
