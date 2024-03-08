import 'package:android_attendance_system/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required TextEditingController emailController,
    required this.preIcon,
    required this.title,
    this.obscureText = false,
  }) : _emailController = emailController;

  final TextEditingController _emailController;
  final Widget preIcon;
  final String title;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: const BoxDecoration(
        color: kTransparent,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: TextFormField(
        controller: _emailController,
        obscureText: obscureText,
        autofocus: false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        style: GoogleFonts.inter(
          textStyle: const TextStyle(
            color: kText,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        decoration: InputDecoration(
          hintText: title,
          prefixIcon: preIcon,
          hintStyle: GoogleFonts.inter(
            textStyle: const TextStyle(
              color: kGray,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kViolet),
            gapPadding: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kbgLight),
            gapPadding: 20,
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: kbgLight),
            gapPadding: 20,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
