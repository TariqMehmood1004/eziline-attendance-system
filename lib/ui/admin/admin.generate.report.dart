// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:android_attendance_system/constants/colors.dart';
import 'package:android_attendance_system/services/firebase/firebase_services.dart';
import 'package:android_attendance_system/widgets/my_button_widget.dart';
import 'package:android_attendance_system/widgets/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminGenerateReportScreen extends StatefulWidget {
  const AdminGenerateReportScreen({super.key});

  @override
  _AdminGenerateReportScreenState createState() =>
      _AdminGenerateReportScreenState();
}

class _AdminGenerateReportScreenState extends State<AdminGenerateReportScreen> {
  DateTime fromdate = DateTime.now();
  DateTime todate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final dateParts = formattedDate.split('-');
    fromdate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
        int.parse(dateParts[2]));
    todate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
        int.parse(dateParts[2]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyTextWidget(
          title: "Generate Report",
          fontSize: 20,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Select From Date:'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButtonWidget(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: fromdate,
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != fromdate) {
                    setState(() {
                      fromdate = picked;
                    });
                  }
                },
                kWidth: 200,
                title: fromdate.toString() == 'null'
                    ? "Select From Date"
                    : DateFormat('yyyy-MM-dd').format(fromdate).toString(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Select To Date:'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButtonWidget(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: todate,
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != todate) {
                    setState(() {
                      todate = picked;
                    });
                  }
                },
                kWidth: 200,
                title: todate.toString() == 'null'
                    ? "Select to Date"
                    : DateFormat('yyyy-MM-dd')
                        .format(todate)
                        .toString()
                        .toString(),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButtonWidget(
                onTap: () async {
                  log("Generating Report: ${fromdate.toIso8601String()} - ${todate.toIso8601String()}");
                  FirebaseService.generateReport(
                      fromdate.toIso8601String(), todate.toIso8601String());
                },
                title: "Generate Report",
                kWidth: 200,
                backgroundColor: kText.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
