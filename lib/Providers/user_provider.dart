// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supplink/Backend/storage/firebase_storage_.dart';

import 'package:supplink/models/user_model.dart';

import '../utils/image_picker.dart';

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
      // print(getUser.isonline);
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

  Uint8List? _profileImage;
  Uint8List? get profileImage => _profileImage;
  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    _profileImage = image;
    // print(profileImage);
    notifyListeners();
  }

  String? _profileUrl;
  String? get profileUrl => _profileUrl;

  Future<void> generateProfileUrl() async {
    try {
      _profileUrl = await StorageMethods()
          .uploadImageToStorage(profileImage!, false, 'profile', user.uid);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> updateUserData(UserData userData) async {
    String res = '';

    try {
      await _firestore
          .collection('Users')
          .doc(userData.uid)
          .update(userData.toJson());
      res = "updated";
      refreshUserData();
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<void> updateUserStatus(Map<String, dynamic> data) async {
    // print("update function  $data['isonline']");
    await _firestore
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
    refreshUserData();
    notifyListeners();
  }
}
