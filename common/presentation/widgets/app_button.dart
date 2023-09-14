// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final ButtonStyle style;
  final VoidCallback onPressed;
  final String text;
  final double? width;
  final TextStyle? textStyle;
  final double? height;
  final bool useWidth;

  const MyButton({
    Key? key,
    required this.style,
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.width,
    this.useWidth = false,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 70,
      width: useWidth ? width : 320,
      child: ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle ??
              GoogleFonts.leagueSpartan(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
