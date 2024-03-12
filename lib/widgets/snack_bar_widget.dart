import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarWidget({
  required BuildContext context,
  required String title,
  Color bgColor = kViolet,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(title, style: const TextStyle(color: fg100)),
      duration: const Duration(seconds: 15),
      backgroundColor: bgColor,
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: fg100,
        disabledTextColor: fg100,
        onPressed: () {
          // Code to execute.
          Get.back();
        },
      ),
    ),
  );
}
