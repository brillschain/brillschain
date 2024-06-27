import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supplink/models/post_model.dart';

import '../models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final User _user = FirebaseAuth.instance.currentUser!;
  List<PostData>? _posts;
  UserData? _userData;
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  List<PostData>? get posts => _posts;
  UserData get userData => _userData!;

  Future<void> refreshUserData(String uid) async {
    try {
      var data = await _firestore.collection('Users').doc(uid).get();
      _userData = UserData.fromSnapshot(data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("error in provider in user data ${e.toString()}");
    }
  }

  void getPosts(String uid) {
    _firestore
        .collection('posts')
        .where('uid', isEqualTo: uid)
        .snapshots(includeMetadataChanges: true)
        .listen((response) {
      _posts = response.docs.map((doc) => PostData.fromSnapshot(doc)).toList();
      notifyListeners();
    });
  }
}
