import 'package:amazon_clone/common/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Constants.backgroundColor,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Constants.backgroundColor,
          body: Center(
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }
}
