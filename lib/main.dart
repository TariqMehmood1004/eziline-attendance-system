import 'package:android_attendance_system/firebase_options.dart';
import 'package:android_attendance_system/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'bloc/bloc_export.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/service_export.dart';
import 'ui/ui_export.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check if the user is logged in
  bool isLoggedIn = FirebaseService.isLoggedIn();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterBloc()),
        BlocProvider(create: (_) => AuthBloc()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eziline Attendance System',
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        home: isLoggedIn ? const HomeScreen() : const WelcomeScreen(),
      ),
    ),
  );
}
