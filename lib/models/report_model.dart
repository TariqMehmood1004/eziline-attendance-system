// Report model
class Report {
  String userId;
  DateTime fromDate;
  DateTime toDate;
  int totalDays;
  int presentDays;
  int absentDays;
  int leaveDays;

  Report({
    required this.userId,
    required this.fromDate,
    required this.toDate,
    required this.totalDays,
    required this.presentDays,
    required this.absentDays,
    required this.leaveDays,
  });

  // fromMap
  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      userId: map['userId'],
      fromDate: DateTime.parse(map['fromDate']),
      toDate: DateTime.parse(map['toDate']),
      totalDays: map['totalDays'],
      presentDays: map['presentDays'],
      absentDays: map['absentDays'],
      leaveDays: map['leaveDays'],
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'totalDays': totalDays,
      'presentDays': presentDays,
      'absentDays': absentDays,
      'leaveDays': leaveDays,
    };
  }
}
