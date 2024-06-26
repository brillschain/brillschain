import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:supplink/Backend/firebasefirestore/firestore_methods.dart';

import 'package:supplink/models/user_model.dart';

import '../models/post_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser!;
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  UserData? _userData;
  List<UserData>? _allUserData;
  UserData get getUser => _userData!;
  List<UserData> get getAllUserData => _allUserData!;
  List<PostData>? _posts;
  List<PostData> get posts => _posts!;
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

  void getPosts(String uid) async {
    var response =
        await _firestore.collection('posts').where('uid', isEqualTo: uid).get();
    _posts = response.docs.map((doc) => PostData.fromSnapshot(doc)).toList();
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
