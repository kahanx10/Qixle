// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final bool obscureText;
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const MyTextField({
    Key? key,
    required this.obscureText,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        hintStyle: GoogleFonts.leagueSpartan(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            width: 2.5,
            color: Colors.black26,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            width: 2.5,
            color: Colors.black26,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            width: 2.5,
            color: Colors.black,
          ),
        ),
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }
}
