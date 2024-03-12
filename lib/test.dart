// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants/constant_export.dart';
import 'ui/auth/signup/sign_up_with_username_screen.dart';
import 'widgets/my_button_widget.dart';
import 'widgets/text_form_field_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double kWidth = MediaQuery.of(context).size.width;
    double kHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Form(
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
          ],
        ),
      ),
    );
  }
}
