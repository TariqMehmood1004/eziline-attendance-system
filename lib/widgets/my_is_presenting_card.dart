import 'package:android_attendance_system/constants/colors.dart';
import 'package:flutter/material.dart';

import '../services/firebase/firebase_services.dart';
import 'widget_export.dart';

class MyIsPresentCardWidget extends StatelessWidget {
  const MyIsPresentCardWidget({
    super.key,
    this.isPresent = Colors.green,
    required this.title,
    required this.total,
    this.isGradeShow = false,
    this.totalGrades = 0,
  });

  final Color isPresent;
  final String title;
  final String total;
  final bool isGradeShow;
  final int totalGrades;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green.withOpacity(0.1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MyTextWidget(
                title: title,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: kGray,
              ),
              MyTextWidget(
                title: total,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: kGray,
              ),
            ],
          ),
          const SizedBox(width: 10),
          isGradeShow
              ? Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: kGray.withOpacity(0.1),
                  ),
                  child: MyTextWidget(
                    title: FirebaseService.calculateGrade(totalGrades),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
