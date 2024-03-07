import 'package:android_attendance_system/ui/ui_export.dart';
import 'package:flutter/material.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return const CounterScreen(
      title: 'Eziline',
    );
  }
}
