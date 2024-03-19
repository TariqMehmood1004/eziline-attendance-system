// Leave request model

class LeaveRequest {
  String id;
  String userId;
  DateTime date;
  bool isApproved;

  LeaveRequest({
    required this.id,
    required this.userId,
    required this.date,
    required this.isApproved,
  });

  // fromMap
  factory LeaveRequest.fromMap(Map<String, dynamic> map) {
    return LeaveRequest(
      id: map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      date: DateTime.tryParse(map['date']?.toString() ?? '') ?? DateTime.now(),
      isApproved: map['isApproved'] ?? false,
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(), // Use 'date' instead of 'startDate'
      'isApproved': isApproved,
    };
  }
}
