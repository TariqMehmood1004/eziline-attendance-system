// ignore_for_file: override_on_non_overriding_member, prefer_const_constructors
import 'dart:developer';

import 'package:android_attendance_system/services/firebase/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/model_export.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is FetchUser) {
      yield* _mapFetchUserToState();
    } else if (event is AttendanceFetchUser) {
      yield* _mapAttendanceFetchUserToState();
    }
  }
}

Stream<UserState> _mapFetchUserToState() async* {
  yield UserLoading();
  try {
    // Assume you have a method to fetch the user data from Firestore
    // Replace `fetchUserDataFromFirestore` with your actual method
    Map<String, dynamic> userData = await fetchUserDataFromFirestore();

    // Convert the retrieved data into UserModel
    UserModel user = UserModel.fromMap(userData);

    yield UserLoaded(user);
  } catch (e) {
    yield const UserError('Failed to fetch user data');
  }
}

Future<Map<String, dynamic>> fetchUserDataFromFirestore() async {
  try {
    FirebaseService firebaseService = FirebaseService();
    UserModel currentUser = await firebaseService.getCurrentUser(
        currentUserId: FirebaseAuth.instance.currentUser!.uid);
    return currentUser.toMap();
  } catch (e) {
    log('Error fetching user data from Firestore: $e');
    rethrow;
  }
}

Stream<UserState> _mapAttendanceFetchUserToState() async* {
  yield UserLoading();
  try {
    UserModel currentUser = await FirebaseService().getCurrentUser(
      currentUserId: FirebaseAuth.instance.currentUser!.uid,
    );

    // Assume you have a method to fetch the user data from Firestore
    // Replace `fetchUserDataFromFirestore` with your actual method
    Map<String, dynamic> userData = await fetchUserDataFromFirestore();

    // Convert the retrieved data into UserModel
    UserModel user = UserModel.fromMap(userData);

    yield UserLoaded(user);

    if (currentUser.attendanceList.isNotEmpty) {
      // Mark attendance for the current user
      Attendance newAttendance = Attendance(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser.id,
        date: DateTime.now(),
        isPresent: true,
      );
      currentUser.attendanceList.add(newAttendance);
      currentUser.attendanceList.last.isPresent = true;
      // Update the user data in Firestore
      await FirebaseService.markAttendanceAndUpdateUserDataInFirestore(
          currentUser);

      // Store attendance in Firestore
      FirebaseService firebaseService = FirebaseService();
      await firebaseService.markAttendance(newAttendance);

      yield AttendanceMarked();
    } else {
      yield AttendanceError('Attendance already marked for today');
    }
  } catch (e) {
    yield UserError('Failed to fetch user data');
  }
}
