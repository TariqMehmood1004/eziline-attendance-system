import 'package:android_attendance_system/constants/colors.dart';
import 'package:android_attendance_system/models/user_model.dart';
import 'package:android_attendance_system/ui/admin/show.student.data.dart';
import 'package:android_attendance_system/welcome_screen.dart';
import 'package:android_attendance_system/widgets/circular_image_widget.dart';
import 'package:android_attendance_system/widgets/flutter_toast_message.dart';
import 'package:android_attendance_system/widgets/my_button_widget.dart';
import 'package:android_attendance_system/widgets/my_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../services/firebase/firebase_services.dart';

class AdminHomeScreenWidget extends StatefulWidget {
  const AdminHomeScreenWidget({super.key});

  @override
  State<AdminHomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<AdminHomeScreenWidget> {
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final dateParts = formattedDate.split('-');
    now = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
        int.parse(dateParts[2]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              child: const MyTextWidget(
                title: "Welcome Admin",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kGray,
              ),
            ),
            const SizedBox(height: 20),
            //
            // add calendar with current date and time.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: kGray.withOpacity(0.1),
                border: Border.all(color: kGray.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(children: [
                    const MyTextWidget(
                      title: "Today",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: kGray,
                    ),
                    const SizedBox(width: 20),
                    MyTextWidget(
                      title: DateTime.now().toString().substring(0, 10),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: kGray,
                    ),
                  ]),
                  Row(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: kGray.withOpacity(0.1),
                        border: Border.all(color: kGray.withOpacity(0.1)),
                      ),
                      child: IconButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Get.offAll(() => const WelcomeScreen());
                        },
                        icon: const Icon(Icons.logout, color: kGray, size: 17),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyTextWidget(
                  title: "App Users",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kGray,
                ),
                Icon(Icons.person, color: kGray, size: 16),
              ],
            ),
            const SizedBox(height: 20),

            Column(children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseService.getAllUsers(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return Card(
                          surfaceTintColor: kTransparent,
                          elevation: 0,
                          child: ListTile(
                            hoverColor: kTransparent,
                            tileColor: kTransparent,
                            selectedColor: kTransparent,
                            selectedTileColor: kTransparent,
                            dense: true,
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Edit Attendance"),
                                    content: Row(
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          size: 17.5,
                                        ),
                                        const SizedBox(width: 10),
                                        MyTextWidget(
                                          title: snapshot.data!.docs[index]
                                              ['name'],
                                          fontSize: 14,
                                          color: kGray,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            const Text(
                                                'Select Date for Attendance: '),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: MyButtonWidget(
                                                backgroundColor:
                                                    kText.withOpacity(0.5),
                                                onTap: () async {
                                                  final DateTime? picked =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: now,
                                                    firstDate:
                                                        DateTime(2015, 8),
                                                    lastDate: DateTime(2101),
                                                  );
                                                  if (picked != null &&
                                                      picked != now) {
                                                    setState(() {
                                                      now = picked;
                                                    });
                                                  }
                                                },
                                                kWidth: 200,
                                                title: now.toString() == 'null'
                                                    ? "Select Date for Attendance"
                                                    : DateFormat('yyyy-MM-dd')
                                                        .format(now)
                                                        .toString(),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: MyButtonWidget(
                                                onTap: () async {
                                                  final currentUser =
                                                      FirebaseAuth
                                                          .instance.currentUser;
                                                  if (currentUser != null) {
                                                    Map<String, dynamic>
                                                        userData = {
                                                      'id': snapshot.data!
                                                          .docs[index]['id'],
                                                      'name': snapshot.data!
                                                          .docs[index]['name'],
                                                      'email': snapshot.data!
                                                          .docs[index]['email'],
                                                      'profilePictureUrl': snapshot
                                                              .data!.docs[index]
                                                          ['profilePictureUrl'],
                                                      'attendanceList': [],
                                                      'leaveRequests': [],
                                                    };
                                                    await FirebaseService
                                                        .markAttendanceAndUpdateUserDataInFirestore(
                                                            pickedDate: now,
                                                            isNow: true,
                                                            UserModel.fromMap(
                                                                userData));

                                                    Get.back();
                                                  } else {
                                                    showToast(
                                                        "User not logged in, cannot mark attendance.");
                                                  }
                                                },
                                                title: "Upload Attendance",
                                                kWidth: 200,
                                                backgroundColor:
                                                    kText.withOpacity(0.3),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
                            onTap: () {
                              UserModel user = UserModel.fromFirestore(
                                  snapshot.data!.docs[index]);
                              Get.to(() => ShowSpecificUserData(user: user));
                            },
                            title: MyTextWidget(
                              title: snapshot.data!.docs[index]['name'],
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: kWhite.withOpacity(0.8),
                              issoftWrap: false,
                            ),
                            leading: CircularImageWidget(
                              kWidget: 40,
                              kHeight: 40,
                              isNetworkImage: true,
                              imagePath: snapshot.data!.docs[index]
                                  ['profilePictureUrl'],
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(Icons.verified_user,
                                    size: 17, color: kText),
                                const SizedBox(width: 5),
                                MyTextWidget(
                                  title: snapshot.data!.docs[index]['isAdmin']
                                      ? "Admin"
                                      : "Student",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: kText,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Text('No data available');
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
