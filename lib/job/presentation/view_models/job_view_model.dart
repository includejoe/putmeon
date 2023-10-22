import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobpulse/job/domain/models/job.dart';
import 'package:jobpulse/user/domain/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class JobViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var uuid = const Uuid();

  bool hasMatchingSkill(String userSkills, String jobSkills) {
    List<String> userSkillList = userSkills.split(',').map((e) => e.trim().toLowerCase()).toList();
    List<String> jobSkillList = jobSkills.split(',').map((e) => e.trim().toLowerCase()).toList();

    for (var userSkill in userSkillList) {
      if (jobSkillList.contains(userSkill)) {
        return true;
      }
    }

    return false;
  }

  // // Get All Jobs
  Future<List<JobModel?>?> getAllJobs(UserModel user) async {
    List<JobModel?>? jobs;

    try {
      QuerySnapshot snapshot = await _firestore
        .collection("jobs")
        .orderBy("timestamp", descending: true)
        .get();

      if(user.isCompany) {
        jobs = snapshot.docs.map((e) => JobModel.fromSnap(e)).toList();
      } else {
        jobs = snapshot.docs.map((e) => JobModel.fromSnap(e))
            .where((job) => hasMatchingSkill(user.skills ?? "", job.skillsRequired))
            .toList();
      }
    } catch (error) {
      debugPrint(error.toString());
      jobs = null;
    }

    return jobs;
  }

  // Get Job Applicants
  Future<List<UserModel?>?> getJobApplicants(String jobId) async {
    try {
      CollectionReference jobs = _firestore.collection("jobs");
      DocumentSnapshot jobSnapshot = await jobs.doc(jobId).get();
      Map<String, dynamic> jobMap = jobSnapshot.data() as Map<String, dynamic>;
      List<String> applications = List<String>.from(jobMap['applications'] ?? []);

      List<UserModel?> applicants = await Future.wait(
        applications.map((applicantId) async {
          DocumentSnapshot userSnapshot =
          await _firestore.collection("users").doc(applicantId).get();
          if (userSnapshot.exists) {
            return UserModel.fromSnap(userSnapshot);
          } else {
            return null;
          }
        }),
      );

      return applicants;
    } catch(error) {
      debugPrint(error.toString());
      return null;
    }
  }

  // Get User Jobs Posted
  Future<List<JobModel?>?> getUserJobsPosted(String userId) async {
    try {
        QuerySnapshot snapshot = await _firestore
          .collection("jobs")
          .where("userId", isEqualTo: userId)
          .orderBy("timestamp", descending: true)
          .get();
        List<JobModel?>? jobs = snapshot.docs.map((e) => JobModel.fromSnap(e)).toList();
        return jobs;
    } catch(error) {
      debugPrint(error.toString());
      return null;
    }
  }

  // Add Job
  Future<bool> addJob({
    String? id,
    required String companyName,
    required String jobTitle,
    required String description,
    required String skillsRequired,
    required String location,
    required String type,
    required String experienceLevel,
    required bool opened,
    String? userProfilePic,
  }) async {
    bool successful = false;
    User currentUser = _auth.currentUser!;

    try {
      CollectionReference jobs = _firestore.collection("jobs");
      final newId = uuid.v4();

      // if id is not null, then we are updating the document
      await jobs.doc(id ?? newId).set({
        "id": id ?? newId,
        "userId": currentUser.uid,
        "companyName": companyName,
        "jobTitle": jobTitle,
        "description": description,
        "skillsRequired": skillsRequired,
        "location": location,
        "type": type,
        "experienceLevel": experienceLevel,
        "opened": opened,
        "userProfilePic": userProfilePic,
        "applications": [],
        "datePosted": DateTime.now().toString(),
        "timestamp": FieldValue.serverTimestamp()
      }, SetOptions(merge: true));

      successful = true;
    } catch(error) {
      successful = false;
    }

    return successful;
  }

  // Update Open Status
  Future<bool> updateJobOpened({
    required String id,
    required bool opened,
  }) async {
    bool successful = false;

    try {
      CollectionReference jobs = _firestore.collection("jobs");

      // if id is not null, then we are updating the document
      await jobs.doc(id).set({
        "opened": opened,
        "timestamp": FieldValue.serverTimestamp()
      }, SetOptions(merge: true));

      successful = true;
    } catch(error) {
      successful = false;
    }

    return successful;
  }

  // Apply Job
  Future<String> applyJob({
    required String jobId,
    required String userId,
  }) async {
    String response = "error";

    try {
      CollectionReference jobs = _firestore.collection("jobs");
      DocumentSnapshot jobSnapshot = await jobs.doc(jobId).get();
      Map<String, dynamic> jobMap = jobSnapshot.data() as Map<String, dynamic>;
      List<dynamic> applications = (jobMap['applications'] as List<dynamic>) ?? [];

      // If the userId is already in applications
      if (applications.contains(userId)) {
        response = "already-applied";
      } else {
        // Append userId to the applications array
        applications.add(userId);

        // Update the document with the updated applications array and timestamp
        await jobs.doc(jobId).set({
          "applications": applications,
        }, SetOptions(merge: true));

        response = "success";
      }
    } catch (error) {
      debugPrint(error.toString());
      response = "error";
    }

    return response;
  }

  // Delete Job
  Future<bool> deleteJob({required String id}) async {
    bool successful = false;

    try {
      CollectionReference jobs = _firestore.collection("jobs");
      await jobs.doc(id).delete();
      successful = true;
    } catch(error) {
      successful = false;
    }
    return successful;
  }
}