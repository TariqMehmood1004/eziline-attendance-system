import 'package:android_attendance_system/constants/colors.dart';
import 'package:flutter/material.dart';

class MyButtonWidget extends StatelessWidget {
  const MyButtonWidget({
    super.key,
    required this.kWidth,
    required this.title,
    required this.onTap,
  });

  final double kWidth;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      splashColor: kViolet,
      highlightColor: kViolet,
      focusColor: kViolet,
      hoverColor: kViolet,
      onTap: onTap,
      child: Container(
        width: kWidth * 0.8,
        height: 47.0,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: kViolet,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: fg100,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
