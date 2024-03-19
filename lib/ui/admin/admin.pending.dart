import 'package:android_attendance_system/constants/colors.dart';
import 'package:android_attendance_system/services/firebase/firebase_services.dart';
import 'package:android_attendance_system/widgets/flutter_toast_message.dart';
import 'package:android_attendance_system/widgets/my_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminPendingScreen extends StatelessWidget {
  const AdminPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: MyTextWidget(
                    title: "Pending Request Leaves",
                    color: kGray,
                    fontSize: 20,
                  ),
                ),
                Icon(Icons.request_page, color: kGray, size: 16),
              ],
            ),
            Column(children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseService.getAllPendingLeaves(),
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
                          'No pending leaves found.',
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
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const MyTextWidget(
                            title:
                                "Tap on refresh icon to accept leave request",
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: kText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: MyTextWidget(
                            title: "Pendings: ${snapshot.data!.docs.length}",
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: kText,
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
                                trailing: Material(
                                  color: kText.withOpacity(0.4),
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100.0),
                                    splashColor: kText.withOpacity(0.4),
                                    onTap: () async {
                                      // Toggle the isApproved field
                                      bool isApproved = !snapshot
                                          .data!.docs[index]['isApproved'];
                                      // Update the isApproved field in Firestore
                                      if (isApproved) {
                                        FirebaseFirestore.instance
                                            .collection('leaveRequests')
                                            .doc(snapshot.data!.docs[index].id)
                                            .update({'isApproved': true});
                                        showToast(
                                            "Leave Request Accepted for ${snapshot.data!.docs[index].id}");
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        snapshot.data!.docs[index]['isApproved']
                                            ? Icons.done
                                            : Icons.refresh,
                                        color: kWhite,
                                        size: 17.0,
                                      ),
                                    ),
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
            ]),
          ],
        ),
      ),
    );
  }
}
