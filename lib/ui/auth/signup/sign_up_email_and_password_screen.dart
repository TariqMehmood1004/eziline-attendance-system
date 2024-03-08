// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, sized_box_for_whitespace

import 'package:android_attendance_system/constants/colors.dart';
import 'package:android_attendance_system/ui/auth/Signup/sign_up_with_username_screen.dart';
import 'package:android_attendance_system/widgets/widget_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpWithEmailAndPasswordScreen extends StatelessWidget {
  const SignUpWithEmailAndPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    double kWidth = MediaQuery.of(context).size.width;
    double kHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AssetImageWidget(imagePath: "assets/images/login.png"),
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
                      const SizedBox(height: 12.0),
                      MyButtonWidget(
                        kWidth: kWidth,
                        title: 'Next',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            Get.to(
                              () => SignUpWithUserNameScreen(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
