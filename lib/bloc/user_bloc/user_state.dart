// States
import 'package:equatable/equatable.dart';

import '../../models/model_export.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

// UserState
class AttendanceMarked extends UserState {}

class AttendanceError extends UserState {
  final String message;

  const AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}
