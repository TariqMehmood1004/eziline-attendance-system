// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:android_attendance_system/constants/colors.dart';
import 'package:android_attendance_system/widgets/widget_export.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    double kWidth = MediaQuery.of(context).size.width;
    double kHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Column(
          children: [
            const AssetImageWidget(imagePath: "assets/images/login.jpg"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormFieldWidget(
                      title: "Email",
                      emailController: _emailController,
                      preIcon: const Icon(Icons.email, color: kGray),
                    ),
                    TextFormFieldWidget(
                      title: "Password",
                      obscureText: true,
                      emailController: _passwordController,
                      preIcon: const Icon(Icons.password, color: kGray),
                    ),
                    const SizedBox(height: 20.0),
                    MyButtonWidget(
                      kWidth: kWidth,
                      title: 'Sign Up',
                      onTap: () {},
                    ),
                    const SizedBox(height: 20.0),
                    RichText(
                        text: TextSpan(
                            text: 'Already have an account?',
                            style: const TextStyle(color: kText),
                            children: [
                          TextSpan(
                              onEnter: (event) {
                                Navigator.pushNamed(context, '/login');
                              },
                              text: ' Login',
                              style: const TextStyle(
                                  color: kViolet, fontWeight: FontWeight.bold))
                        ])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
