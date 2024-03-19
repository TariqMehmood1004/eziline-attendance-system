// ignore_for_file: unused_field, unused_local_variable, no_leading_underscores_for_local_identifiers, use_rethrow_when_possible, deprecated_member_use, unnecessary_null_comparison, depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:android_attendance_system/models/attendance_model.dart';
import 'package:android_attendance_system/models/leave_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../constants/colors.dart';
import '../../ui/ui_export.dart';
import '../../widgets/widget_export.dart';
import '../../models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseService {
  final _firebaseAuthInstance = FirebaseAuth.instance;
  final _picker = ImagePicker();
  static String? imageUrl;

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  static User? currentUser = FirebaseAuth.instance.currentUser;

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference _leaveRequestsCollection =
      FirebaseFirestore.instance.collection('leaveRequests');

  Future<void> updateLeaveRequestAndUsers(LeaveRequest leaveRequest) async {
    try {
      // Update the leave request
      await _leaveRequestsCollection.doc(leaveRequest.id).update({
        'isApproved': leaveRequest.isApproved,
      });

      // Update users associated with the leave request
      List<String> userIds = leaveRequest.userId as List<String>;
      for (String userId in userIds) {
        DocumentSnapshot userSnapshot =
            await _usersCollection.doc(userId).get();

        if (userSnapshot.exists) {
          UserModel user = UserModel.fromFirestore(userSnapshot);

          // Update the user's leave request status
          for (int i = 0; i < user.leaveRequests.length; i++) {
            if (user.leaveRequests[i].id == leaveRequest.id) {
              user.leaveRequests[i].isApproved = leaveRequest.isApproved;
              break;
            }
          }

          // Update the user document
          await _usersCollection.doc(userId).update(user.toMap());
        }
      }
    } catch (e) {
      showToast('Error updating leave request and users: $e');
      rethrow;
    }
  }

  static Future<QuerySnapshot<Object?>> getAllPendingLeaveRequests() async {
    try {
      final CollectionReference _leaveRequestsCollection =
          FirebaseFirestore.instance.collection('leaveRequests');

      QuerySnapshot leaveRequestsSnapshot = await _leaveRequestsCollection
          .where('isApproved', isEqualTo: false)
          .get();

      return leaveRequestsSnapshot;
    } catch (e) {
      showToast('Error fetching pending leave requests: $e');
      rethrow;
    }
  }

  static Stream<QuerySnapshot> getAllPendingLeaves() {
    return FirebaseFirestore.instance
        .collection('leaveRequests')
        .where('isApproved', isEqualTo: false)
        .snapshots();
  }

  static Stream<QuerySnapshot> getAllAcceptedLeaves() {
    return FirebaseFirestore.instance
        .collection('leaveRequests')
        .where('isApproved', isEqualTo: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getAllAttendanceFor(String userId) {
    return FirebaseFirestore.instance
        .collection('attendance')
        .where('isPresent', isEqualTo: true)
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  static Future<void> deleteRecordForId(
    String collection,
    String id,
    String userId,
  ) async {
    await FirebaseFirestore.instance.collection(collection).doc(id).delete();

    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    List<dynamic> attendanceList = userSnapshot['attendanceList'];
    attendanceList.remove(id); // This line attempts to delete

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'attendanceList': attendanceList});

    showToast('Record deleted successfully');
  }

  static Future<void> generateReport(String fromDate, String toDate) async {
    QuerySnapshot<Map<String, dynamic>> attendanceSnapshot =
        await FirebaseFirestore.instance
            .collection('attendance')
            .where('date', isGreaterThanOrEqualTo: fromDate)
            .where('date', isLessThanOrEqualTo: toDate)
            .get();

    Map<String, Map<String, dynamic>> userAttendance = {};
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in attendanceSnapshot.docs) {
      String userId = documentSnapshot['userId'];
      if (!userAttendance.containsKey(userId)) {
        userAttendance[userId] = {
          'name': '',
          'email': '',
          'attendanceList': [],
          'leaveRequests': [],
        };
      }
      userAttendance[userId]!['attendanceList'].add(documentSnapshot.data());
    }

    QuerySnapshot<Map<String, dynamic>> usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    Map<String, Map<String, dynamic>> userData = {};
    for (QueryDocumentSnapshot<Map<String, dynamic>> userSnapshot
        in usersSnapshot.docs) {
      userData[userSnapshot.id] = {
        'name': userSnapshot['name'],
        'email': userSnapshot['email'],
        'attendanceList': userSnapshot.data()['attendanceList'].toList(),
        'leaveRequests': userSnapshot.data()['leaveRequests'].toList(),
      };
    }

    QuerySnapshot<Map<String, dynamic>> leaveRequestsSnapshot =
        await FirebaseFirestore.instance
            .collection('leaveRequests')
            .where('date', isGreaterThanOrEqualTo: fromDate)
            .where('date', isLessThanOrEqualTo: toDate)
            .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in leaveRequestsSnapshot.docs) {
      String userId = documentSnapshot['userId'];
      if (!userAttendance.containsKey(userId)) {
        userAttendance[userId] = {
          'name': '',
          'email': '',
          'attendanceList': [],
          'leaveRequests': [],
        };
      }
      userAttendance[userId]!['leaveRequests'].add(documentSnapshot.data());
    }

    if (userAttendance.isEmpty && leaveRequestsSnapshot.docs.isEmpty) {
      showToast('No data available');
      return;
    }

    showModalBottomSheet(
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      context: Get.context!,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: userData.length,
            itemBuilder: (context, index) {
              var currentUser = userData.values.elementAt(index);
              int totalAttendance = currentUser['attendanceList'].length;
              int totalLeaves = currentUser['leaveRequests'].length;
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
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  onTap: () {},
                  title: MyTextWidget(
                    title: currentUser['name'],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: kWhite.withOpacity(0.8),
                    issoftWrap: false,
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.verified_user, size: 17, color: kText),
                      const SizedBox(width: 5),
                      MyTextWidget(
                        title: currentUser['email'],
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: kText,
                      ),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyTextWidget(
                        title: 'Presents: $totalAttendance',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: kText,
                      ),
                      MyTextWidget(
                        title: 'Absents: $totalLeaves',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: kText,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static Future<dynamic> showImageSelectionDialog() async {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const MyTextWidget(
              title: 'Upload Image',
              color: kwhite,
              fontWeight: FontWeight.w500,
              fontSize: 18.0),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: ListBody(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: kGray.withOpacity(0.1),
                  ),
                  child: GestureDetector(
                    child: const MyTextWidget(
                      title: 'Camera',
                      color: kwhite,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap: () async {
                      imageUrl = await uploadImageFromCameraToStorage();
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(height: 5.0),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: kGray.withOpacity(0.1),
                  ),
                  child: GestureDetector(
                    child: const MyTextWidget(
                      title: 'Gallery',
                      color: kwhite,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap: () async {
                      imageUrl = await uploadImageFromGalleryToStorage();
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> updateUserData({String? name}) async {
    try {
      if (name != "" && imageUrl != null) {
        User? currentUser = _auth.currentUser;
        if (currentUser == null) {
          throw Exception('User not logged in');
        }

        // Call uploadImageFromGalleryToStorage to get the image URL
        Map<String, dynamic> userData = {
          'id': currentUser.uid,
          'email': currentUser.email,
          'name': name,
          'createdAt': Timestamp.now(),
          'lastLoginAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
          'profilePictureUrl': imageUrl,
        };

        if (userData.isNotEmpty) {
          await firestore
              .collection('users')
              .doc(currentUser.uid)
              .update(userData);

          showToast('User data updated successfully');
        } else {
          showToast('No user data to update');
        }
      } else {
        showToast('Please select an image and enter a name');
      }
    } catch (e) {
      showToast('Error updating user data: $e');
      throw e;
    }
  }

  static Future<int> getDocsLengthForUser(
      String documentPath, String compareFieldNameWithUser) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection(documentPath)
              .where(compareFieldNameWithUser, isEqualTo: currentUserId)
              .get();

      return snapshot.docs.length;
    } catch (e) {
      showToast('Error getting document length: $e');
      throw e;
    }
  }

  static Future<String> getImageUrl(
      String documentPath, String fieldName) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection(documentPath)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        String imageUrl = data[fieldName];
        return imageUrl;
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      showToast('Error getting image URL: $e');
      log('Error getting image URL: $e');
      throw e;
    }
  }

  static Future<UserModel?> getCurrentUserModel() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (userSnapshot.exists) {
        return UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      showToast('Error getting current user: $e');
      return null;
    }
  }

  Future<UserModel> getCurrentUser({required String currentUserId}) async {
    try {
      DocumentSnapshot userDoc =
          await _usersCollection.doc(currentUserId).get();
      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      log('Error fetching current user: $e');
    }

    // Return empty user model if user not found
    return UserModel(
      id: '',
      name: '',
      email: '',
      profilePictureUrl: '',
      attendanceList: [],
      leaveRequests: [],
    );
  }

  // get current logged in user data from firestore
  static Future<UserModel> getUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.doc("users/$uid").get();

    return UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
  }

  static Future<void> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String imageUrl,
  }) async {
    try {
      UserCredential createUserAccount = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // String imageUrl = await uploadImageToStorage();

      UserModel user = UserModel(
        id: createUserAccount.user!.uid,
        name: name,
        email: createUserAccount.user!.email!,
        profilePictureUrl: imageUrl,
        attendanceList: [],
        leaveRequests: [],
        isAdmin: false,
      );

      // Convert user object to a map and store in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .set(user.toMap());

      if (createUserAccount.user != null) {
        Get.offAll(() => const HomeScreen());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showToast("The account already exists for that email.");
      } else if (e.code == 'invalid-email') {
        showToast("The email address is badly formatted.");
      } else if (e.code == 'operation-not-allowed') {
        showToast("Email/password accounts are not enabled.");
      } else if (e.code == 'network-request-failed') {
        showToast("Check your internet connection.");
      } else if (e.code == "error_weak_password") {
        showToast("The password provided is too weak.");
      } else {
        showToast("An error occurred while creating the account.");
      }
    } catch (e) {
      showToast("An error occurred while creating the account.");
      throw e;
    }
  }

  static Future<String> uploadImageFromGalleryToStorage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      throw Exception('No image selected');
    }

    final file = File(pickedFile.path);

    // Load the image
    final bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    // Compress the image
    image = img.copyResize(image!, width: 500); // Resize the image to width 500
    final compressedBytes =
        img.encodeJpg(image, quality: 85); // Compress the image

    // Save the compressed image to a temporary file
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp.jpg');
    await tempFile.writeAsBytes(compressedBytes);

    // Upload the compressed image to Firebase Storage
    final fileName = file.path.split('/').last;
    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/$fileName');
    final uploadTask = ref.putFile(tempFile);

    final snapshot = await uploadTask.whenComplete(() => null);
    final imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }

  static Future<String> uploadImageFromCameraToStorage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) {
      throw Exception('No image selected');
    }

    final file = File(pickedFile.path);

    // Load the image
    final bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    // Compress the image
    image = img.copyResize(image!, width: 500); // Resize the image to width 500
    final compressedBytes =
        img.encodeJpg(image, quality: 85); // Compress the image

    // Save the compressed image to a temporary file
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp.jpg');
    await tempFile.writeAsBytes(compressedBytes);

    // Upload the compressed image to Firebase Storage
    final fileName = file.path.split('/').last;
    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/$fileName');
    final uploadTask = ref.putFile(tempFile);

    final snapshot = await uploadTask.whenComplete(() => null);
    final imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }

  static bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static Stream<QuerySnapshot> getAllUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  // login method
  static Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // get isAdmin from firestore_database

      // Usage example
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        CollectionReference users =
            FirebaseFirestore.instance.collection('users');

        DocumentSnapshot snapshot = await users.doc(user.uid).get();

        if (snapshot.exists) {
          UserModel userModel =
              UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
          if (userModel.isAdmin!) {
            // User is admin
            Get.offAll(() => const AdminScreen());
          } else {
            Get.offAll(() => const HomeScreen());
          }
        } else {
          showToast("User data not found.");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showToast("The account already exists for that email.");
      } else if (e.code == 'invalid-email') {
        showToast("The email address is badly formatted.");
      } else if (e.code == 'operation-not-allowed') {
        showToast("Email/password accounts are not enabled.");
      } else if (e.code == 'network-request-failed') {
        showToast("Check your internet connection.");
      } else if (e.code == "error_weak_password") {
        showToast("The password provided is too weak.");
      } else {
        showToast("An error occurred while creating the account.");
      }
    } catch (e) {
      showToast("An error occurred while creating the account.");
      throw e;
    }
  }

  static Future<void> loggedOut() {
    return FirebaseAuth.instance.signOut();
  }

  Future<void> storeLeaveRequest(LeaveRequest leaveRequest) async {
    try {
      final CollectionReference _leaveRequestsCollection =
          FirebaseFirestore.instance.collection('leaveRequests');

      // Check if the user has already requested leave for today
      bool leaveExistsForToday = await _leaveRequestsCollection
          .where('userId', isEqualTo: leaveRequest.userId)
          .where('startDate', isEqualTo: leaveRequest.date)
          .get()
          .then((querySnapshot) {
        return querySnapshot.docs.isNotEmpty;
      });

      // Wait for the leave request check to complete before proceeding
      leaveExistsForToday;

      // If leave for today does not exist, set the leave request data
      if (leaveExistsForToday == false) {
        await _leaveRequestsCollection
            .doc("${leaveRequest.id}_${leaveRequest.userId}")
            .set(leaveRequest.toMap());

        showToast("Leave request sent successfully.");
      } else {
        showToast(
            "You have already requested leave for today. You can't request leave again.");
      }
    } catch (e) {
      showToast("An error occurred while storing leave request.");
      throw e;
    }
  }

  static Future<List<DateTime>> getCollectionFieldForCurrentUser({
    required String collectionName,
    required String fieldName,
    required String isEqualTo,
  }) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection(collectionName)
              .where(fieldName, isEqualTo: isEqualTo)
              .where('userId', isEqualTo: currentUserId)
              .get();

      List<DateTime> dates = snapshot.docs.map((doc) {
        return DateTime.parse(doc.data()['date']);
      }).toList();

      log("dates: ${dates.toString()}");
      return dates;
    } catch (e) {
      showToast('Error getting attendance dates: $e');
      throw e;
    }
  }

  Future<void> markAttendance(Attendance attendance) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final attendanceRef = firestore.collection('attendance');
      final today = DateTime.now();

      final formattedDate = "${today.year}-${today.month}-${today.day}";

      // Check for existing attendance for the user on the same day
      final snapshot = await attendanceRef
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('date', isEqualTo: formattedDate)
          .get();

      if (snapshot.docs.isEmpty) {
        // No attendance found, store new attendance
        final attendanceId = attendanceRef.doc().id;
        attendance.id = attendanceId; // Set unique ID for the attendance record
        await attendanceRef.doc(attendanceId).set(attendance.toMap());
      }
    } catch (e) {
      showToast("An error occurred while storing attendance.");
      throw e;
    }
  }

  static DateTime convertToFormattedDate(DateTime? now) {
    final today = now ?? DateTime.now();
    final formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final dateParts = formattedDate.split('-');
    return DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
        int.parse(dateParts[2]));
  }

  static Future<void> markAttendanceAndUpdateUserDataInFirestore(UserModel user,
      {DateTime? pickedDate, bool isNow = false}) async {
    try {
      // 1. Check for existing attendance in Firestore (source of truth)
      final attendanceRef = FirebaseFirestore.instance.collection('attendance');

      final today = DateTime.now();
      final date = convertToFormattedDate(today);

      final dates = await FirebaseService.getCollectionFieldForCurrentUser(
          collectionName: 'attendance',
          fieldName: 'date',
          isEqualTo: date.toIso8601String());

      // Check if there is no existing attendance for today
      if (dates.isEmpty) {
        // 2. Store attendance in Firestore with unique ID
        final attendanceId = attendanceRef.doc().id;
        final newAttendance = Attendance(
          id: attendanceId,
          userId: user.id,
          date: isNow ? convertToFormattedDate(pickedDate) : date,
          isPresent: true,
        );
        log("pickedDate: $pickedDate");
        log("date: $date");
        await attendanceRef.doc(attendanceId).set(newAttendance.toMap());

        // 3. Update user document only for specific fields
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .update({
          'attendanceList': FieldValue.arrayUnion([newAttendance.toMap()]),
        });

        showToast("Attendance marked successfully.");
      } else {
        showToast("Attendance already marked for today.");
      }
    } catch (e) {
      log("Error marking attendance: $e");
      showToast("Error marking attendance: $e");
      throw e;
    }
  }

  static Future<void> updateUserDataInFirestoreForLeaveRequests(
      UserModel user) async {
    try {
      // 1. Check for existing attendance in Firestore (source of truth)
      final leaveRef = FirebaseFirestore.instance.collection('leaveRequests');

      final today = DateTime.now();
      final formattedDate =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      final dateParts = formattedDate.split('-');
      final date = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
          int.parse(dateParts[2]));

      final dates = await FirebaseService.getCollectionFieldForCurrentUser(
          collectionName: 'leaveRequests',
          fieldName: 'date',
          isEqualTo: date.toIso8601String());

      // Check if there is no existing attendance for today
      if (dates.isEmpty) {
        // 2. Store attendance in Firestore with unique ID
        final leaveId = leaveRef.doc().id;
        final newleave = LeaveRequest(
          id: leaveId,
          userId: user.id,
          date: date,
          isApproved: false,
        );
        await leaveRef.doc(leaveId).set(newleave.toMap());

        // 3. Update user document only for specific fields
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .update({
          'leaveRequests': FieldValue.arrayUnion([newleave.toMap()]),
        });

        showToast("Leave request sent successfully.");
      } else {
        showToast("Leave request already sent for today.");
      }
    } catch (e) {
      log("Error marking attendance: $e");
      showToast("Error marking attendance: $e");
      throw e;
    }
  }

  static String calculateGrade(int attendanceDays) {
    if (attendanceDays >= 26) {
      return 'A';
    } else if (attendanceDays >= 21) {
      return 'B';
    } else if (attendanceDays >= 16) {
      return 'C';
    } else if (attendanceDays >= 11) {
      return 'D';
    } else {
      return 'F';
    }
  }
}
