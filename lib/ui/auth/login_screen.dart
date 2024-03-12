// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, sized_box_for_whitespace

import 'package:android_attendance_system/constants/colors.dart';
import 'package:android_attendance_system/widgets/widget_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc_export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                height: kHeight * 0.45,
                child: const AssetImageWidget(
                    imagePath: "assets/images/signin.png"),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyTextWidget(
                        title: "Welcome back!",
                        fontWeight: FontWeight.bold,
                        color: kViolet,
                        fontSize: 27.0,
                      ),
                      SizedBox(height: 12.0),
                      MyTextWidget(
                        title: "Log in to manage attendance effortlessly.",
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
                        title: 'Log In',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<AuthBloc>(context).add(
                              LoginEvent(
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
