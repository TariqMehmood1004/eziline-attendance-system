// ignore_for_file: unused_field, override_on_non_overriding_member

import 'package:android_attendance_system/bloc/auth_bloc/auth_export.dart';
import 'package:android_attendance_system/services/firebase/firebase_services.dart';
import 'package:android_attendance_system/services/service_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  AuthBloc() : super(const AuthStates()) {
    on<SignUpEvent>((event, emit) async {
      emit(SignUpInProgressState());

      try {
        await FirebaseService.signUpWithEmailAndPassword(
          email: event.email,
          password: event.password,
          name: event.name,
        );
        emit(SignUpSuccessState());
      } catch (e) {
        emit(SignUpFailureState(errorMessage: e.toString()));
      }
    });
  }
}
