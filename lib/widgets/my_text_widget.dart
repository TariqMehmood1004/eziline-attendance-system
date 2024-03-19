import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constant_export.dart';

class MyTextWidget extends StatelessWidget {
  const MyTextWidget({
    super.key,
    required this.title,
    this.fontSize = 27,
    this.fontWeight = FontWeight.w500,
    this.color = kWhite,
    this.issoftWrap = true,
  });
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final bool issoftWrap;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      softWrap: issoftWrap,
      style: GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
