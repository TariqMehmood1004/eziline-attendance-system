import 'package:android_attendance_system/ui/ui_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc_export.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterBloc()),
      ],
      child: const CounterScreen(
        title: 'Eziline Attendance System',
      ),
    ),
  );
}
