import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/common/presentation/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageService {
  static void showSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      padding: const EdgeInsets.all(12),
      content: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Constants.selectedColor,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          message,
          style: GoogleFonts.leagueSpartan(
            color: Constants.selectedColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      showCloseIcon: true,
      closeIconColor: Constants.selectedColor,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Constants.backgroundColor,
    ));
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
