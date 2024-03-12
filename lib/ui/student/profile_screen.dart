// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

import '../../bloc/bloc_export.dart';
import '../../constants/constant_export.dart';
import '../../widgets/widget_export.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        color: kTransparent,
        margin: const EdgeInsets.only(top: 70),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const MyTextWidget(
                title: "My Profile",
                fontWeight: FontWeight.w500,
                fontSize: 27,
                color: kGray,
              ),
              const SizedBox(height: 20),
              ClipRRect(
                child: Material(
                  borderRadius: BorderRadius.circular(100),
                  color: kTransparent,
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          ImagePickerRepository().pickImageFromGallery();
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: kGray,
                              border: Border.fromBorderSide(BorderSide(
                                color: kGray,
                                width: 3,
                              ))),
                          child: const CircularImageWidget(),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 30,
                        child: Icon(Icons.edit_square,
                            color: kWhite.withOpacity(0.7), size: 20),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // const MyTextWidget(
              //   title: "Tariq Mehmood",
              //   fontWeight: FontWeight.w500,
              //   fontSize: 22,
              //   color: kGray,
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  children: [
                    TextFormFieldWidget(
                      textInputType: TextInputType.name,
                      title: "Name",
                      emailController: _nameController,
                      preIcon: const Icon(Icons.person, color: kGray),
                    ),
                    TextFormFieldWidget(
                      textInputType: TextInputType.emailAddress,
                      title: "Email",
                      emailController: _emailController,
                      preIcon: const Icon(Icons.email, color: kGray),
                    ),
                    MyButtonWidget(
                      title: "Update",
                      onTap: () {
                        snackBarWidget(
                          context: context,
                          title: "Profile Updated",
                          bgColor: kblueDark,
                        );
                      },
                      kWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
