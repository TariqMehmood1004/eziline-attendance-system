import 'dart:async';

class AttendanceBloc {
  final _attendanceController = StreamController<int>.broadcast();
  Stream<int> get attendanceStream => _attendanceController.stream;

  void updateAttendanceLength(int length) {
    _attendanceController.sink.add(length);
  }

  void dispose() {
    _attendanceController.close();
  }
}
