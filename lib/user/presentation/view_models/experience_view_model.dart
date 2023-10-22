import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobpulse/user/domain/models/experience.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ExperienceViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var uuid = const Uuid();

  // Get Experiences
  Future<List<ExperienceModel?>?> getUserExperiences(String? userId) async {
    User currentUser = _auth.currentUser!;
    List<ExperienceModel?>? experiences;

    try {

      if(userId != null) {
        QuerySnapshot snapshot = await _firestore
            .collection("experiences")
            .where("userId", isEqualTo: userId)
            .orderBy("timestamp", descending: true)
            .get();
          experiences = snapshot.docs.map((e) => ExperienceModel.fromSnap(e)).toList();
      } else {
        QuerySnapshot snapshot = await _firestore
            .collection("experiences")
            .where("userId", isEqualTo: currentUser.uid)
            .orderBy("timestamp", descending: true)
            .get();
        experiences = snapshot.docs.map((e) => ExperienceModel.fromSnap(e)).toList();
      }

    } catch(error) {
      debugPrint(error.toString());
      experiences = null;
    }

    return experiences;
  }

  // Add Experience
  Future<bool> addExperience({
    String? id,
    required String company,
    required String jobTitle,
    required String description,
    required String startDate,
    required String endDate,
  }) async {
    bool successful = false;
    User currentUser = _auth.currentUser!;

    try {
      CollectionReference experiences = _firestore.collection("experiences");
      final newId = uuid.v4();

      // if id is not null, then we are updating the document
      await experiences.doc(id ?? newId).set({
        "id": id ?? newId,
        "userId": currentUser.uid,
        "company": company,
        "jobTitle": jobTitle,
        "description": description,
        "startDate": startDate,
        "endDate": endDate,
        "timestamp": FieldValue.serverTimestamp()
      }, SetOptions(merge: true));

      successful = true;
    } catch(error) {
      successful = false;
    }

    return successful;
  }

  // Delete Experience
  Future<bool> deleteExperience({required String id}) async {
    bool successful = false;

    try {
      CollectionReference experiences = _firestore.collection("experiences");
      await experiences.doc(id).delete();
      successful = true;
    } catch(error) {
      successful = false;
    }
    return successful;
  }
}