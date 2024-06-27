import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User _user = FirebaseAuth.instance.currentUser!;
  int? _noOfPosts;
  UserData? _userData;
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  bool _isCurrentUser = false;
  bool get isCurrentUser => _isCurrentUser;
  int get noOfPosts => _noOfPosts ?? 0;
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

  void getNoOfPosts(String uid) async {
    var res =
        await _firestore.collection('posts').where('uid', isEqualTo: uid).get();
    _noOfPosts = res.docs.length;
    notifyListeners();
  }

  void currentUser(String uid) {
    _isCurrentUser = uid == _user.uid;
    notifyListeners();
  }

  bool? _isConnection;
  bool get isConnection => _isConnection ?? false;
  void connection() {
    print(userData.connections);
    _isConnection = userData.connections.contains(_user.uid);

    notifyListeners();
  }

  Future<void> updateUserData() async {}
}
