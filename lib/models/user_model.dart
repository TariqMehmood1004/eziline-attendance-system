import './model_export.dart';

// User model
class UserModel {
  String id;
  String name;
  String email;
  String profilePictureUrl;
  List<Attendance> attendanceList;
  List<LeaveRequest> leaveRequests;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePictureUrl,
    required this.attendanceList,
    required this.leaveRequests,
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
    };
  }
}
