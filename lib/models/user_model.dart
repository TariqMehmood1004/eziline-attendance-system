import 'package:cloud_firestore/cloud_firestore.dart';

import './model_export.dart';

// User model
class UserModel {
  String id;
  String name;
  String email;
  String profilePictureUrl;
  bool? isAdmin;
  List<Attendance> attendanceList;
  List<LeaveRequest> leaveRequests;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePictureUrl,
    required this.attendanceList,
    required this.leaveRequests,
    this.isAdmin = false,
  });

  // fromMap
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      profilePictureUrl: map['profilePictureUrl'],
      attendanceList: [],
      leaveRequests: [],
      isAdmin: map['isAdmin'],
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      isAdmin: data['isAdmin'],
      profilePictureUrl: data['profilePictureUrl'],
      attendanceList: List<Attendance>.from(
          (data['attendanceList'] ?? []).map((x) => Attendance.fromMap(x))),
      leaveRequests: List<LeaveRequest>.from(
          (data['leaveRequests'] ?? []).map((x) => LeaveRequest.fromMap(x))),
    );
  }

  //toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'attendanceList': [],
      'leaveRequests': [],
      'isAdmin': isAdmin,
    };
  }
}
