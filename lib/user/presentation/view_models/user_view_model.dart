import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jobpulse/base/di/get_it.dart';
import 'package:jobpulse/base/providers/user_provider.dart';
import 'package:jobpulse/base/utils/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobpulse/user/domain/models/user.dart';

class UserViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _userProvider = getIt<UserProvider>();

  // Get User Details
  Future<UserModel> getUserDetails(String? userId) async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot = await _firestore
      .collection("users")
      .doc(userId ?? currentUser.uid)
      .get();

    return UserModel.fromSnap(snapshot);
  }

  // Register New User
  Future<bool> registerUser({
    required String email,
    required String password,
    required String name,
    required String headline,
    required bool isCompany,
  }) async {
    bool successful = false;

    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      await _firestore.collection("users").doc(credentials.user!.uid).set({
        "uid": credentials.user!.uid,
        "email": email,
        "name": name,
        "headline": headline,
        "isCompany": isCompany,
      });

      successful = true;
    } catch(error) {
      successful = false;
    }

    return successful;
  }

  // Login User
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    bool successful = false;

    try {
      UserCredential credentials = await _auth.signInWithEmailAndPassword(email: email, password: password);
      getUserDetails(credentials.user!.uid).then((details) {
        _userProvider.user = details;
      });
      successful = true;
    } catch (error) {
      successful = false;
    }

    return successful;
  }

  // Update User
  Future<bool> updateUser({
    required String name,
    required String headline,
    required String bio,
    required String skills,
    required String? imageUrl,
    Uint8List? profileImage
  }) async {
    bool successful = false;

    if (profileImage != null) {
      imageUrl = await StorageMethods().uploadImageToStorage("profile_pics", profileImage, false);
    }

    try {
      await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
        "name": name,
        "headline": headline,
        "bio": bio,
        "skills": skills,
        "profilePic": imageUrl
      }, SetOptions(merge: true));
      successful = true;
    } catch(error) {
      successful = false;
    }
    return successful;
  }

  // Sign Out
  Future<bool> signOut() async {
    bool successful = false;

    try {
      await _auth.signOut();
      successful = true;
    } catch(error) {
      successful = false;
    }

    return successful;
  }
}