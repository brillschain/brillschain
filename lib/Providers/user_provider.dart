import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:supplink/models/user_model.dart';

// import '../models/post_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser!;
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  UserData? _userData;
  List<UserData>? _allUserData;
  UserData get getUser => _userData!;
  List<UserData> get getAllUserData => _allUserData!;
  int? _posts;
  int get posts => _posts ?? 0;
  Future<void> refreshUserData() async {
    try {
      var data = await _firestore.collection('Users').doc(user.uid).get();
      _userData = UserData.fromSnapshot(data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("error in provider in user data ${e.toString()}");
    }
  }

  void getPosts() async {
    var response = await _firestore
        .collection('posts')
        .where('uid', isEqualTo: user.uid)
        .get();
    _posts = response.docs.length;
    // print(_posts);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshAllUserData() async {
    try {
      _firestore
          .collection('Users')
          .snapshots(includeMetadataChanges: true)
          .listen((response) {
        _allUserData =
            response.docs.map((doc) => UserData.fromSnapshot(doc)).toList();
        notifyListeners();
      });
    } catch (e) {
      print("error in provider in all user data  ${e.toString()}");
    }
  }
}
