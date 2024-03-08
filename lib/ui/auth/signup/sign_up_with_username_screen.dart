// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, sized_box_for_whitespace

import 'dart:developer';
import 'package:android_attendance_system/constants/colors.dart';
import 'package:android_attendance_system/ui/ui_export.dart';
import 'package:android_attendance_system/widgets/widget_export.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpWithUserNameScreen extends StatelessWidget {
  const SignUpWithUserNameScreen({
    super.key,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    log("email: $email, \npassword: $password");

    final _nameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    double kWidth = MediaQuery.of(context).size.width;
    double kHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        dragStartBehavior: DragStartBehavior.down,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Center(
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
                        title: "Username",
                        emailController: _nameController,
                        preIcon: const Icon(Icons.email, color: kGray),
                      ),
                      const SizedBox(height: 12.0),
                      MyButtonWidget(
                        kWidth: kWidth,
                        title: 'Next',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            Get.to(
                              () => SignUpWithProfileScreen(
                                email: email,
                                password: password,
                                name: _nameController.text,
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
