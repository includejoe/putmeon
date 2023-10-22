import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String id;
  final String userId;
  final String companyName;
  final String jobTitle;
  final String description;
  final String skillsRequired;
  final String location;
  final String type;
  final String datePosted;
  final String experienceLevel;
  final bool opened;
  final List<dynamic> applications;
  final String? userProfilePic;

  const JobModel({
    required this.id,
    required this.userId,
    required this.companyName,
    required this.jobTitle,
    required this.description,
    required this.skillsRequired,
    required this.location,
    required this.type,
    required this.datePosted,
    required this.experienceLevel,
    required this.opened,
    required this.applications,
    this.userProfilePic,
  });

  static JobModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return JobModel (
      id: snapshot["id"],
      userId: snapshot["userId"],
      companyName: snapshot["companyName"],
      jobTitle: snapshot["jobTitle"],
      description: snapshot["description"],
      skillsRequired: snapshot["skillsRequired"],
      location: snapshot["location"],
      type: snapshot["type"],
      datePosted: snapshot["datePosted"],
      experienceLevel: snapshot["experienceLevel"],
      opened: snapshot["opened"],
      applications: snapshot["applications"],
      userProfilePic: snapshot["userProfilePic"]
    );
  }
}