import 'package:cloud_firestore/cloud_firestore.dart';

class ExperienceModel {
  final String id;
  final String userId;
  final String company;
  final String jobTitle;
  final String description;
  final String startDate;
  final String endDate;

  const ExperienceModel({
    required this.id,
    required this.userId,
    required this.company,
    required this.jobTitle,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "company": company,
    "jobTitle": jobTitle,
    "description": description,
    "startDate": startDate,
    "endDate": endDate,
  };

  static ExperienceModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ExperienceModel (
      id: snapshot["id"],
      userId: snapshot["userId"],
      company: snapshot["company"],
      jobTitle: snapshot["jobTitle"],
      description: snapshot["description"],
      startDate: snapshot["startDate"],
      endDate: snapshot["endDate"],
    );
  }
}