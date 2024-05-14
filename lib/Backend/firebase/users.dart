import 'package:cloud_firestore/cloud_firestore.dart';

class User_Details {
  final String uid;
  final String name;
  final String email;
  final String image;
  final DateTime lastseen;
  final bool isonline;
  final String profile;

  User_Details(
      {required this.uid,
      required this.name,
      required this.email,
      required this.image,
      required this.lastseen,
      this.isonline = false,
      this.profile = ''});

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "image": image,
      "isonline": isonline,
      "lastseen": lastseen,
    };
  }

  factory User_Details.fromJson(Map<String, dynamic> json) => User_Details(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      image: json['profile'],
      lastseen: (json['lastseen'] as Timestamp).toDate(),
      isonline: json['isOnline'] ?? false,
      profile: json['profileUrl'] ?? '');
}
