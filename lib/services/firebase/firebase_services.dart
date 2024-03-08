// ignore_for_file: unused_field, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/widget_export.dart';
import '../../models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseService {
  final _firebaseAuthInstance = FirebaseAuth.instance;
  final _picker = ImagePicker();

  static Future<void> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential createUserAccount = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String imageUrl = await uploadImageToStorage();

      UserModel user = UserModel(
        id: createUserAccount.user!.uid,
        name: name,
        email: createUserAccount.user!.email!,
        profilePictureUrl: imageUrl,
        attendanceList: [],
        leaveRequests: [],
      );

      // Convert user object to a map and store in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .set(user.toMap());

      snackBarWidget(
        context: Get.context!,
        title: 'Account created successfully for ${user.email}.',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        snackBarWidget(
          context: Get.context!,
          title: 'The password provided is too weak.',
        );
      } else if (e.code == 'email-already-in-use') {
        snackBarWidget(
          context: Get.context!,
          title: 'The account already exists for that email.',
        );
      } else {
        snackBarWidget(
          context: Get.context!,
          title: 'An error occurred while creating the account.',
        );
      }
    } catch (e) {
      log(e.toString());
      snackBarWidget(
        context: Get.context!,
        title: 'An error occurred while creating the account.',
      );
    }
  }

  static Future<String> uploadImageToStorage() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      throw Exception('No image selected.');
    }

    final firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('profile_images/${DateTime.now().millisecondsSinceEpoch}');

    final firebase_storage.UploadTask uploadTask = storageRef.putFile(
      File(pickedFile.path),
      firebase_storage.SettableMetadata(contentType: 'image/jpeg'),
    );

    final firebase_storage.TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();

    return url;
  }
}
