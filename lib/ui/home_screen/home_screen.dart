// ignore_for_file: unused_field, unused_element, non_constant_identifier_names, sized_box_for_whitespace, use_build_context_synchronously, unused_local_variable, unnecessary_null_comparison, prefer_const_constructors

import 'dart:developer';

import 'package:android_attendance_system/bloc/user_bloc/user_state.dart';
import 'package:android_attendance_system/models/attendance_model.dart';
import 'package:android_attendance_system/models/user_model.dart';
import 'package:android_attendance_system/services/firebase/firebase_services.dart';
import 'package:android_attendance_system/welcome_screen.dart';
import 'package:android_attendance_system/widgets/my_is_presenting_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../constants/colors.dart';
import '../../widgets/widget_export.dart';
import '../ui_export.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
                  const SizedBox(width: 5),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: kText.withOpacity(0.1),
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

          //
          // add present and abset card with their totals.
          const SizedBox(height: 20),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return MyIsPresentCardWidget(
                  isPresent: Colors.green.withOpacity(0.2),
                  title: "Present",
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

              int presentCount = user.attendanceList
                  .where((attendance) => attendance.isPresent)
                  .length;

              int leaveCount = user.leaveRequests
                  .where((leave) => leave.isApproved == true)
                  .length;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyIsPresentCardWidget(
                    isPresent: Colors.green.withOpacity(0.2),
                    title: "Present",
                    total: presentCount.toString(),
                    isGradeShow: true,
                    totalGrades: presentCount,
                  ),
                  MyIsPresentCardWidget(
                    isPresent: Colors.green.withOpacity(0.2),
                    title: "Absent",
                    total: leaveCount.toString(),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 120),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is AttendanceMarked) {
                return const Text('Attendance Marked');
              } else if (state is AttendanceError) {
                return Text('Error: ${state.message}');
              } else {
                return MyButtonWidget(
                  title: "Mark Attendance",
                  onTap: () async {
                    // Get the current user (assuming you have a way to access it)
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      Map<String, dynamic> userData = {
                        'id': currentUser.uid,
                        'name': currentUser.displayName ?? '',
                        'email': currentUser.email ?? '',
                        'profilePictureUrl': currentUser.photoURL ?? '',
                        'attendanceList': [],
                        'leaveRequests': [],
                      };
                      await FirebaseService
                          .markAttendanceAndUpdateUserDataInFirestore(
                              UserModel.fromMap(userData));
                    } else {
                      // Handle the case where the user is not logged in
                      showToast("User not logged in, cannot mark attendance.");
                    }
                  },
                  kWidth: MediaQuery.of(context).size.width * 0.8,
                  backgroundColor: kTransparent,
                  borderColor: kGray.withOpacity(0.2),
                  foregroundColor: kGray.withOpacity(0.8),
                );
              }
            },
          ),

          const SizedBox(height: 20),
          MyButtonWidget(
            title: "Mark Leave",
            onTap: () async {
              // Get the current user (assuming you have a way to access it)
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser != null) {
                Map<String, dynamic> userData = {
                  'id': currentUser.uid,
                  'name': currentUser.displayName ?? '',
                  'email': currentUser.email ?? '',
                  'profilePictureUrl': currentUser.photoURL ?? '',
                  'attendanceList': [],
                  'leaveRequests': [],
                };
                log(userData.toString());

                await FirebaseService.updateUserDataInFirestoreForLeaveRequests(
                    UserModel.fromMap(userData));
              } else {
                showToast("User not logged in, cannot sent leave request.");
              }
            },
            kWidth: MediaQuery.of(context).size.width * 0.8,
            borderColor: kGray.withOpacity(0.2),
            backgroundColor: kTransparent,
            foregroundColor: kGray.withOpacity(0.8),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreenWidget(),
    Text("Inbox Screen"),
    ShowAllAttendanceReportScreen(),
    Text("No Features for Settings Screen"),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user's information
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user == null) {
      return const Scaffold(
          body: Center(
        child: Text("Welcome Screen"),
      ));
    }

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: kGray.withOpacity(0.15),
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: kTransparent,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          elevation: 0.0,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home, color: kBottomNavigationBarFgColor),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.inbox, color: kBottomNavigationBarFgColor),
              label: 'Inbox',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: kGray.withOpacity(0.2),
                  border: Border.all(color: kGray.withOpacity(0.2), width: 1.0),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: const Icon(
                  Icons.report,
                  size: 27,
                  color: kWhite,
                ),
              ),
              label: '', // No label
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: kBottomNavigationBarFgColor),
              label: 'Settings',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person, color: kBottomNavigationBarFgColor),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          iconSize: 22.0,
          unselectedFontSize: 12.0,
          onTap: _onItemTapped,
        ),
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
    );
  }
}

class ShowAllAttendanceReportScreen extends StatefulWidget {
  const ShowAllAttendanceReportScreen({super.key});

  @override
  State<ShowAllAttendanceReportScreen> createState() =>
      _ShowAllAttendanceReportScreenState();
}

class _ShowAllAttendanceReportScreenState
    extends State<ShowAllAttendanceReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: kTransparent,
        title: const MyTextWidget(
          title: "Attendance Report",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: kWhite,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showToast("Clear All");
            },
            icon: const Icon(Icons.clear_all, color: kWhite),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder<int>(
                      future: FirebaseService.getDocsLengthForUser(
                          "attendance", "userId"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const MyTextWidget(
                            title: "February 2024 (loading...)",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kGray,
                          );
                        } else if (snapshot.hasError) {
                          return const MyTextWidget(
                            title: "February 2024 (Error)",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kGray,
                          );
                        } else {
                          return MyTextWidget(
                            title: "February 2024 (${snapshot.data ?? "0"})",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kGray,
                          );
                        }
                      },
                    ),
                    const Icon(Icons.calendar_month, size: 17, color: kGray),
                  ],
                ),
              ),
              Column(children: [
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('attendance')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Extract the list of attendance documents
                      List<QueryDocumentSnapshot> documents =
                          snapshot.data!.docs;

                      // Map each document to its data and create a list of Attendance objects
                      List<Attendance> attendanceList = documents.map((doc) {
                        Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;
                        return Attendance.fromMap(data);
                      }).toList();

                      // Display the attendance list or a message if no attendance records are found
                      if (attendanceList.isNotEmpty) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: attendanceList.length,
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                visualDensity:
                                    VisualDensity.adaptivePlatformDensity,
                                onTap: () {},
                                title: MyTextWidget(
                                  title: DateFormat('yyyy-MM-dd')
                                      .format(attendanceList[index].date),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: kWhite.withOpacity(0.8),
                                ),
                                leading: FutureBuilder<String>(
                                  future: FirebaseService.getImageUrl(
                                      'users', 'profilePictureUrl'),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      String imageUrl = snapshot.data!;
                                      return CircularImageWidget(
                                        kWidget: 40,
                                        kHeight: 40,
                                        isNetworkImage: true,
                                        imagePath: imageUrl,
                                      );
                                    }
                                  },
                                ),
                                subtitle: Row(
                                  children: [
                                    const Icon(Icons.done_all,
                                        size: 17, color: kText),
                                    const SizedBox(width: 5),
                                    MyTextWidget(
                                      title: attendanceList[index].isPresent
                                          ? "Present"
                                          : "Absent",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: kText,
                                    ),
                                  ],
                                ),
                                trailing: Material(
                                  color: kText.withOpacity(0.4),
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100.0),
                                    splashColor: kText.withOpacity(0.4),
                                    onTap: () {},
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.more_vert,
                                        color: kWhite,
                                        size: 17.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                            child: Text('No attendance records found'));
                      }
                    }
                  },
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
