import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUser extends UserEvent {}

class AttendanceFetchUser extends UserEvent {}

// UserEvent
class MarkAttendance extends UserEvent {}
