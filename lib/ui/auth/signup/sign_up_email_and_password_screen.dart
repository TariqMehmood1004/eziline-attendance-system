// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, sized_box_for_whitespace

import 'package:android_attendance_system/constants/colors.dart';
import 'package:android_attendance_system/ui/auth/Signup/sign_up_with_username_screen.dart';
import 'package:android_attendance_system/widgets/widget_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpWithEmailAndPasswordScreen extends StatefulWidget {
  const SignUpWithEmailAndPasswordScreen({super.key});

  @override
  State<SignUpWithEmailAndPasswordScreen> createState() =>
      _SignUpWithEmailAndPasswordScreenState();
}

class _SignUpWithEmailAndPasswordScreenState
    extends State<SignUpWithEmailAndPasswordScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double kWidth = MediaQuery.of(context).size.width;
    double kHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: kTransparent,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: kHeight * 0.35,
                child: const AssetImageWidget(
                    imagePath: "assets/images/login.png"),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyTextWidget(
                        title: "Sign up now!",
                        fontWeight: FontWeight.bold,
                        color: kWhite,
                        fontSize: 24.0,
                      ),
                      SizedBox(height: 12.0),
                      MyTextWidget(
                        title:
                            "Join us to streamline your attendance management process. and create your account to unlock the power of our Attendance Management System.",
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        color: kgreyLight,
                      ),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormFieldWidget(
                        title: "Email",
                        obscureText: false,
                        textInputType: TextInputType.emailAddress,
                        emailController: _emailController,
                        preIcon: const Icon(Icons.email, color: kGray),
                      ),
                      TextFormFieldWidget(
                        title: "Password",
                        obscureText: true,
                        textInputType: TextInputType.visiblePassword,
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
                                email: _emailController.text.trim().toString(),
                                password:
                                    _passwordController.text.trim().toString(),
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
