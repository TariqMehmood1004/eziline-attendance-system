// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:android_attendance_system/models/model_export.dart';
import 'package:android_attendance_system/services/firebase/firebase_services.dart';
import 'package:flutter/material.dart';
import '../../constants/constant_export.dart';
import '../../widgets/widget_export.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Container(
          color: kTransparent,
          margin: const EdgeInsets.only(top: 70),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const MyTextWidget(
                  title: "My Profile",
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: kGray,
                ),
                const SizedBox(height: 50),
                StreamBuilder<UserModel>(
                    stream: FirebaseService.getUserData().asStream(),
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          ClipRRect(
                            child: Material(
                              borderRadius: BorderRadius.circular(100),
                              color: kTransparent,
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showToast("Feature unavailable for now!");
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          color: kGray,
                                          border:
                                              Border.fromBorderSide(BorderSide(
                                            color: kGray,
                                            width: 3,
                                          ))),
                                      child: CircularImageWidget(
                                        imagePath:
                                            snapshot.data?.profilePictureUrl ??
                                                "",
                                        isNetworkImage: true,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 30,
                                    child: Icon(Icons.edit_square,
                                        color: kWhite.withOpacity(0.7),
                                        size: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          MyTextWidget(
                            title: snapshot.data?.name ?? "",
                            fontWeight: FontWeight.w500,
                            fontSize: 27,
                            color: kGray,
                          ),
                          const SizedBox(height: 20),
                          MyTextWidget(
                            title: snapshot.data?.isAdmin == true
                                ? "Admin"
                                : "Student",
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: kText,
                          ),
                          const SizedBox(height: 10),
                          MyTextWidget(
                            title: snapshot.data?.email ?? "",
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: kGray.withOpacity(0.7),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                TextFormFieldWidget(
                                  textInputType: TextInputType.name,
                                  title: snapshot.data?.name ?? "",
                                  emailController: _nameController,
                                  preIcon:
                                      const Icon(Icons.person, color: kGray),
                                ),
                                MyButtonWidget(
                                  title: "Update",
                                  onTap: () {
                                    FirebaseService.updateUserData(
                                        name: _nameController.text);
                                  },
                                  kWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
