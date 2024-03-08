// Leave request model

class LeaveRequest {
  String id;
  String userId;
  DateTime startDate;
  DateTime endDate;
  bool isApproved;

  LeaveRequest({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.isApproved,
  });

  // fromMap
  factory LeaveRequest.fromMap(Map<String, dynamic> map) {
    return LeaveRequest(
      id: map['id'],
      userId: map['userId'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      isApproved: map['isApproved'],
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isApproved': isApproved,
    };
  }
}
