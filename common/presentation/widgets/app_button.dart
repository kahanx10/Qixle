// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final ButtonStyle style;
  final VoidCallback onPressed;
  final String label;
  final bool isExpanded;
  final double? width;

  const AppButton({
    Key? key,
    required this.style,
    required this.onPressed,
    required this.label,
    required this.isExpanded,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: style,
                onPressed: onPressed,
                child: Text(label),
              ),
            ),
          )
        : SizedBox(
            width: width!,
            height: 50,
            child: ElevatedButton(
              style: style,
              onPressed: onPressed,
              child: Text(label),
            ),
          );
  }
}
