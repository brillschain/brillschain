import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  final String description;
  final String uid;
  final String name;
  final String address;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profileUrl;
  final likes;

  PostData(
      {required this.description,
      required this.uid,
      required this.username,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.likes,
      required this.name,
      required this.address,
      required this.profileUrl});

  Map<String, dynamic> toJson() => {
        'description': description,
        'username': username,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profileUrl': profileUrl,
        'name': name,
        'address': address,
        'likes': likes
      };

  static PostData fromSnapshot(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return PostData(
        description: snapshot['description'],
        username: snapshot['username'],
        postId: snapshot['postId'],
        datePublished: snapshot['datePublished'],
        postUrl: snapshot['postUrl'],
        profileUrl: snapshot['profileUrl'],
        uid: documentSnapshot["uid"],
        likes: snapshot['likes'],
        name: snapshot['name'],
        address: snapshot['address']);
  }
}
