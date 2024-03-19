import 'package:android_attendance_system/firebase_options.dart';
import 'package:android_attendance_system/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Widget initialRoute = isLoggedIn ? const HomeScreen() : const WelcomeScreen();

  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    DocumentSnapshot snapshot = await users.doc(user.uid).get();

    if (snapshot.exists) {
      dynamic userData = snapshot.data();
      bool isAdmin = userData is Map<String, dynamic> && userData['isAdmin'];

      if (isAdmin) {
        initialRoute = const AdminScreen();
      } else {
        initialRoute = const HomeScreen();
      }
    }
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterBloc()),
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => UserBloc()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eziline Attendance System',
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => initialRoute,
          '/welcome': (context) => const WelcomeScreen(),
        },
      ),
    ),
  );
}
