import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/constant_export.dart';

class MyRichTextWidget extends StatelessWidget {
  const MyRichTextWidget({
    super.key,
    required this.label,
    required this.text,
    required this.onTap,
  });

  final String label;
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(color: kText),
        children: [
          const WidgetSpan(child: SizedBox(width: 15.0)),
          TextSpan(
            text: text,
            style: const TextStyle(
              color: kViolet,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
