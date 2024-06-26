import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supplink/models/post_model.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User _user = FirebaseAuth.instance.currentUser!;
  List<PostData>? _posts;
  // List<String>? _connections;
  List<PostData>? get posts => _posts;
  // List<String>? get connections => _connections;
  void getPosts(String uid) {
    _firestore
        .collection('posts')
        .where('uid', isEqualTo: uid)
        .snapshots(includeMetadataChanges: true)
        .listen((response) {
      _posts = response.docs.map((doc) => PostData.fromSnapshot(doc)).toList();
    });

    notifyListeners();
  }
}
