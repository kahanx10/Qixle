import 'package:amazon_clone/common/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.black,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text(
              'QIXA',
              style: GoogleFonts.playfairDisplay(
                color: Constants.backgroundColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
