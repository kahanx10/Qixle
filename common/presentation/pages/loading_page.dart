import 'package:amazon_clone/common/data/constants.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Constants.loading,
    );
  }
}
