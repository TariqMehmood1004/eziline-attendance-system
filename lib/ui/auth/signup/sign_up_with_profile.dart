// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, sized_box_for_whitespace

import 'dart:developer';

import 'package:android_attendance_system/bloc/bloc_export.dart';
import 'package:android_attendance_system/constants/colors.dart';
import 'package:android_attendance_system/widgets/widget_export.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpWithProfileScreen extends StatelessWidget {
  const SignUpWithProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    log("email: $email, \npassword: $password, \nname: $name");

    final _profileController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    double kWidth = MediaQuery.of(context).size.width;
    double kHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: kContrast,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: kWhite, width: 2),
                    ),
                    child: const Icon(Icons.person, color: kWhite, size: 50),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormFieldWidget(
                        title: "Profile",
                        emailController: _profileController,
                        preIcon: const Icon(Icons.email, color: kGray),
                      ),
                      const SizedBox(height: 12.0),
                      BlocBuilder<AuthBloc, AuthStates>(
                        builder: (context, state) {
                          return MyButtonWidget(
                            kWidth: kWidth,
                            title: 'Sign Up',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<AuthBloc>(context).add(
                                  SignUpEvent(
                                    email: email.trim().toString(),
                                    password: password.trim().toString(),
                                    name: name.trim().toString(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20.0),
                      RichText(
                        text: TextSpan(
                          text: 'Already have an account?',
                          style: const TextStyle(color: kText),
                          children: [
                            const WidgetSpan(child: SizedBox(width: 15.0)),
                            TextSpan(
                              text: 'Login',
                              style: const TextStyle(
                                color: kViolet,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  snackBarWidget(
                                    context: context,
                                    title: "Not yet implemented",
                                  );
                                },
                            ),
                          ],
                        ),
                      )
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
