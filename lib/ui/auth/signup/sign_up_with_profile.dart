// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, sized_box_for_whitespace

import 'dart:developer';
import 'package:android_attendance_system/constants/colors.dart';
import 'package:android_attendance_system/widgets/widget_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth_bloc/auth_export.dart';

class SignUpWithProfileScreen extends StatefulWidget {
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
  State<SignUpWithProfileScreen> createState() =>
      _SignUpWithProfileScreenState();
}

class _SignUpWithProfileScreenState extends State<SignUpWithProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final bool isLoading = false;
  String imageUrl =
      "https://img.freepik.com/free-vector/happy-young-man-smiling_24877-81914.jpg?t=st=1710735267~exp=1710738867~hmac=9d8f24a6cd11c9ea6f4cb564b04c9273dd5671a7fb25eff853300e2fa8b018eb&w=580";
  @override
  Widget build(BuildContext context) {
    log("email: ${widget.email}, \npassword: ${widget.password}, \nname: ${widget.name}");

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
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<AuthBloc, AuthStates>(
                  builder: (context, state) {
                    return Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: kContrast,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: kViolet, width: 3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Material(
                          color: kTransparent,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          elevation: 0.0,
                          child: InkWell(
                            onTap: () => showToast("Coming soon"),
                            borderRadius: BorderRadius.circular(100),
                            child: isLoading
                                ? Center(
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      child: const CircularProgressIndicator(),
                                    ),
                                  )
                                : Image.network(imageUrl, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyTextWidget(
                          title: "Your profile",
                          fontWeight: FontWeight.bold,
                          color: kbgLight,
                          fontSize: 32.0,
                        ),
                        SizedBox(height: 12.0),
                        MyTextWidget(
                          title:
                              "Personalize your profile to make attendance tracking seamless. And update your profile to stay connected and informed.",
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
                        const SizedBox(height: 12.0),
                        BlocBuilder<AuthBloc, AuthStates>(
                          builder: (context, state) {
                            return MyButtonWidget(
                              kWidth: kWidth,
                              title: 'Sign Up',
                              backgroundColor: Colors.green.withOpacity(0.8),
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<AuthBloc>(context).add(
                                    SignUpEvent(
                                      email: widget.email,
                                      password: widget.password,
                                      name: widget.name,
                                      imageUrl: imageUrl,
                                    ),
                                  );
                                }
                              },
                            );
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
      ),
    );
  }
}
