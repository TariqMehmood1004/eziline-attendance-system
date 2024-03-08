// Attendance model
class Attendance {
  String id;
  String userId;
  DateTime date;
  bool isPresent;

  Attendance({
    required this.id,
    required this.userId,
    required this.date,
    required this.isPresent,
  });

  // fromMap
  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      userId: map['userId'],
      date: DateTime.parse(map['date']),
      isPresent: map['isPresent'],
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'isPresent': isPresent,
    };
  }
}
