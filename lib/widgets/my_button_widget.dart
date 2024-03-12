import 'package:android_attendance_system/constants/colors.dart';
import 'package:flutter/material.dart';

class MyButtonWidget extends StatelessWidget {
  const MyButtonWidget({
    super.key,
    required this.kWidth,
    required this.title,
    required this.onTap,
    this.backgroundColor = kViolet,
    this.foregroundColor = fg100,
    this.fontSize = 16.0,
  });

  final double kWidth;
  final double fontSize;
  final String title;
  final Function() onTap;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      splashColor: backgroundColor,
      highlightColor: backgroundColor,
      focusColor: backgroundColor,
      hoverColor: backgroundColor,
      onTap: onTap,
      child: Container(
        width: kWidth * 0.8,
        height: 47.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: foregroundColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
