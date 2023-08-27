import 'package:amazon_clone/common/presentation/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';

class MessageService {
  static void showSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static void showLoadingOverlay(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return const LoadingOverlay();
        },
      ),
    );
  }

  static void popLoadingOverlay(BuildContext context) {
    Navigator.of(context).pop();
  }
}
