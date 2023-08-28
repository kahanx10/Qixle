import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  final String message;

  const MessagePage({super.key, this.message = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(message),
      ),
    );
  }
}
