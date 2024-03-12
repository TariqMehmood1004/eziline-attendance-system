// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, sized_box_for_whitespace

import 'dart:developer';
import 'package:android_attendance_system/constants/colors.dart';
import 'package:android_attendance_system/ui/ui_export.dart';
import 'package:android_attendance_system/widgets/widget_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpWithUserNameScreen extends StatefulWidget {
  const SignUpWithUserNameScreen({
    super.key,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  State<SignUpWithUserNameScreen> createState() =>
      _SignUpWithUserNameScreenState();
}

class _SignUpWithUserNameScreenState extends State<SignUpWithUserNameScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    log("email: ${widget.email}, \npassword: ${widget.password}");

    double kWidth = MediaQuery.of(context).size.width;
    double kHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: kTransparent,
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: kHeight * 0.4,
                  child: const AssetImageWidget(
                      imagePath: "assets/images/login.png")),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyTextWidget(
                        title: "Sign up now!",
                        fontWeight: FontWeight.bold,
                        color: kPink,
                        fontSize: 32.0,
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
                        title: "Username",
                        obscureText: false,
                        textInputType: TextInputType.name,
                        emailController: _nameController,
                        preIcon: const Icon(Icons.person, color: kGray),
                      ),
                      const SizedBox(height: 12.0),
                      MyButtonWidget(
                        kWidth: kWidth,
                        title: 'Next',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            Get.to(() => SignUpWithProfileScreen(
                                  email: widget.email,
                                  password: widget.password,
                                  name: _nameController.text.trim().toString(),
                                ));
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
