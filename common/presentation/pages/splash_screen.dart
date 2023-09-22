import 'package:amazon_clone/common/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Constants.selectedColor,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Constants.selectedColor,
          body: Center(
            child: Image.asset(
              'assets/images/logo.png',
            ).animate().shake(delay: const Duration(seconds: 1)),
          ),
        ),
      ),
    );
  }
}
