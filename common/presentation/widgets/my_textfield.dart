// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon_clone/common/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final bool obscureText;
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? title;

  const MyTextField({
    Key? key,
    required this.obscureText,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.leagueSpartan(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Constants.selectedColor,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      cursorColor: Constants.selectedColor,
      decoration: InputDecoration(
        label: title != null
            ? Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Text(
                  title!.toUpperCase(),
                  style: GoogleFonts.leagueSpartan(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Constants.selectedColor),
                ),
              )
            : null,
        hintStyle: GoogleFonts.leagueSpartan(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade400,
        ),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            width: 2.5,
            color: Colors.grey.shade400,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            width: 2.5,
            color: Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(width: 2.5, color: Constants.selectedColor),
        ),
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }
}
