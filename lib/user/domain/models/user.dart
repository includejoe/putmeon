import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late final String email;
  late final String uid;
  late final String name;
  late final String headline;
  late final bool isCompany;
  late final String? bio;
  late final String? skills;
  late final String? profilePic;
  late final String? location;

  UserModel({
    required this.email,
    required this.uid,
    required this.name,
    required this.headline,
    required this.isCompany,
    this.bio,
    this.skills,
    this.profilePic,
    this.location,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "uid": uid,
    "email": email,
    "headline": headline,
    "isCompany": isCompany,
    "profilePic": profilePic,
    "bio": bio,
    "skills": skills,
    "location": location,
  };

  UserModel.fromJson(dynamic json) {
    uid = json['uid'];
    email = json['email'];
    name = json['name'];
    headline = json['headline'];
    isCompany = json['isCompany'];
    bio = json['bio'];
    skills = json['skills'];
    profilePic = json['profilePic'];
    location = json['location'];
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel (
      name: snapshot["name"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      isCompany: snapshot["isCompany"],
      profilePic: snapshot["profilePic"],
      bio: snapshot["bio"],
      skills: snapshot["skills"],
      headline: snapshot["headline"],
      location: snapshot["location"]
    );
  }
}