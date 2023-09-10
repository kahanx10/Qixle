// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final ButtonStyle style;
  final VoidCallback onPressed;
  final String label;
  final double? width;
  final bool useWidth;

  const MyButton({
    Key? key,
    required this.style,
    required this.onPressed,
    required this.label,
    this.width,
    this.useWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: useWidth ? width : 320,
      height: 70,
      child: ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: Text(
          label,
          style: GoogleFonts.leagueSpartan(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
