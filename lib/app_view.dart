import 'package:flutter/material.dart';

import 'ui/auth/Signup/sign_up_email_and_password_screen.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return const SignUpWithEmailAndPasswordScreen();
  }
}
