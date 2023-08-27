import 'package:amazon_clone/common/data/constant_data.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: ConstantData.secondaryColor,
        ),
      ),
    );
  }
}
