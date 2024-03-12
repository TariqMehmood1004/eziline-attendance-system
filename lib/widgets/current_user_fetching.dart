// ignore_for_file: non_constant_identifier_names

import 'package:android_attendance_system/constants/colors.dart';
import 'package:android_attendance_system/widgets/my_text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Center currentUserFetchedData(User user) {
  return Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      MyTextWidget(
        title: user.uid.toString(),
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: kBlack,
      ),
      MyTextWidget(
        title: user.email.toString(),
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: kBlack,
      ),
      MyTextWidget(
        title: user.emailVerified.toString(),
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: kBlack,
      ),
    ]),
  );
}
