import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants/colors.dart';
import 'ui/ui_export.dart';
import 'widgets/widget_export.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .45,
            child:
                const AssetImageWidget(imagePath: "assets/images/welcome.png"),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30.0),
                  MyTextWidget(
                    title: " Welcome aboard!",
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                    fontSize: 24.0,
                  ),
                  SizedBox(height: 12.0),
                  MyTextWidget(
                    title:
                        "Welcome to our Attendance Management System. Your gateway to effortless attendance tracking.",
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                    color: kgreyLight,
                  ),
                  SizedBox(height: 20.0),
                ]),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyButtonWidget(
                  title: "Login",
                  fontSize: 14.0,
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: kBlack,
                  onTap: () {
                    Get.to(() => const LoginScreen());
                  },
                  kWidth: MediaQuery.of(context).size.width * .45,
                ),
                const SizedBox(width: 20.0),
                MyButtonWidget(
                  title: "Sign Up",
                  fontSize: 14.0,
                  onTap: () {
                    Get.to(() => const SignUpWithEmailAndPasswordScreen());
                  },
                  kWidth: MediaQuery.of(context).size.width * .45,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
