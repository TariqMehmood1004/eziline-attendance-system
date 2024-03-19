// ignore_for_file: unnecessary_null_comparison
import 'package:android_attendance_system/constants/colors.dart';
import 'package:android_attendance_system/models/user_model.dart';
import 'package:android_attendance_system/services/firebase/firebase_services.dart';
import 'package:android_attendance_system/widgets/circular_image_widget.dart';
import 'package:android_attendance_system/widgets/my_is_presenting_card.dart';
import 'package:android_attendance_system/widgets/my_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowSpecificUserData extends StatefulWidget {
  const ShowSpecificUserData({super.key, required this.user});

  final UserModel user;

  @override
  State<ShowSpecificUserData> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<ShowSpecificUserData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kText.withOpacity(0.3),
        title: const MyTextWidget(
          title: "Attendance Record",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: kWhite,
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          CircularImageWidget(
            imagePath: widget.user.profilePictureUrl,
            kWidget: 40,
            kHeight: 40,
            isNetworkImage: true,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.user.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return MyIsPresentCardWidget(
                      isPresent: Colors.green.withOpacity(0.2),
                      title: "Total Presents",
                      total: "Loading...",
                    );
                  }

                  UserModel user = UserModel.fromFirestore(snapshot.data!);

                  if (user.attendanceList == null) {
                    return MyIsPresentCardWidget(
                      isPresent: Colors.green.withOpacity(0.2),
                      title: "Present",
                      total: "0",
                      isGradeShow: false,
                    );
                  }

                  int leaveCount = user.leaveRequests
                      .where((leave) => leave.isApproved == true)
                      .length;

                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kGray.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const MyTextWidget(
                              title: "Total Absents: ",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: kGray,
                            ),
                            MyTextWidget(
                              title: leaveCount.toString(),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: kGray,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseService.getAllAttendanceFor(widget.user.id),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'No attendance record found.',
                          style: TextStyle(
                            color: kGray,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 13),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kGray.withOpacity(0.1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const MyTextWidget(
                                    title: "Total Attendances:",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: kGray,
                                  ),
                                  const SizedBox(width: 40),
                                  MyTextWidget(
                                    title:
                                        snapshot.data!.docs.length.toString(),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: kGray,
                                  ),
                                ],
                              ),
                              MyTextWidget(
                                title: FirebaseService.calculateGrade(
                                    snapshot.data!.docs.length),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: kGray,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            return Card(
                              surfaceTintColor: kTransparent,
                              elevation: 0,
                              child: Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    FirebaseService.deleteRecordForId(
                                        "attendance",
                                        snapshot.data!.docs[index].id,
                                        widget.user.id);
                                  }
                                },
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                  ),
                                ),
                                child: ListTile(
                                  hoverColor: kTransparent,
                                  tileColor: kTransparent,
                                  selectedColor: kTransparent,
                                  selectedTileColor: kTransparent,
                                  dense: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  visualDensity:
                                      VisualDensity.adaptivePlatformDensity,
                                  onTap: () {},
                                  title: MyTextWidget(
                                    title: snapshot.data!.docs[index]['userId'],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: kWhite.withOpacity(0.8),
                                    issoftWrap: false,
                                  ),
                                  subtitle: Row(
                                    children: [
                                      const Icon(Icons.verified_user,
                                          size: 17, color: kText),
                                      const SizedBox(width: 5),
                                      MyTextWidget(
                                        title: DateFormat('yyyy-MM-dd').format(
                                            DateTime.parse(snapshot
                                                .data!.docs[index]['date'])),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: kText,
                                      ),
                                    ],
                                  ),
                                  leading: Container(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: kWhite.withOpacity(0.2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: MyTextWidget(
                                        title: snapshot.data!.docs[index]
                                                ['isPresent']
                                            ? "P"
                                            : "A",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: kWhite,
                                      ),
                                    ),
                                  ),
                                  trailing: MyTextWidget(
                                    title: snapshot.data!.docs[index]
                                            ['isPresent']
                                        ? "Present"
                                        : "Absent",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: kText,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                  return const Text('No data available');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
