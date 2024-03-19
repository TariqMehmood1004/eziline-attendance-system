// ignore_for_file: unused_field, override_on_non_overriding_member, invalid_use_of_visible_for_testing_member

import 'package:android_attendance_system/bloc/auth_bloc/auth_export.dart';
import 'package:android_attendance_system/services/firebase/firebase_services.dart';
import 'package:android_attendance_system/services/service_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  AuthBloc() : super(const AuthStates()) {
    // Check if the user is already logged in
    if (FirebaseService.isLoggedIn()) {
      emit(LoginSuccessState());
    } else {
      emit(const LoginFailureState(errorMessage: "User not logged in"));
    }

    on<SignUpEvent>((event, emit) async {
      emit(SignUpInProgressState());

      try {
        await FirebaseService.signUpWithEmailAndPassword(
          email: event.email,
          password: event.password,
          name: event.name,
          imageUrl: event.imageUrl,
        );
        emit(SignUpSuccessState());
      } catch (e) {
        emit(SignUpFailureState(errorMessage: e.toString()));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(LoginInProgressState());

      try {
        await FirebaseService.loginWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(LoginSuccessState());
      } catch (e) {
        emit(LoginFailureState(errorMessage: e.toString()));
      }
    });

    on<LoggedOutEvent>((event, emit) {
      emit(const LoginFailureState(errorMessage: "User logged out"));
    });
  }
}
