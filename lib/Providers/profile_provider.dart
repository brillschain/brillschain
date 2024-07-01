import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Backend/firebasefirestore/firestore_methods.dart';
import '../models/user_model.dart';
import '../utils/image_picker.dart';

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

  void init(String uid) async {
    _isLoading = true;
    await refreshUserData(uid);
    getNoOfPosts(uid);
    currentUser(uid);
    connection();

    _isLoading = false;
  }

  Future<void> refreshUserData(String uid) async {
    try {
      var data = await _firestore.collection('Users').doc(uid).get();
      _userData = UserData.fromSnapshot(data);

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
    // print(userData.connections);
    _isConnection = userData.connections.contains(_user.uid);

    notifyListeners();
  }

  String? _res;
  String get res => _res!;
  Future<void> manageConnection(String anotherUserId) async {
    try {
      if (isConnection) {
        await FireBaseFireStoreMethods().connectUser(_user.uid, anotherUserId);
        _res = " removed from your connections";
        _isConnection = false;

        notifyListeners();
      } else {
        await FireBaseFireStoreMethods().connectUser(_user.uid, anotherUserId);
        _res = " added to your connections";
        _isConnection = true;

        notifyListeners();
      }
    } catch (e) {
      _res = e.toString();
    }
    // return _res!;
  }

  Uint8List? _profileImage;
  Uint8List? get profileImage => _profileImage;
  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    _profileImage = image;
    // print(profileImage);
    notifyListeners();
  }

  Future<void> updateUserData(UserData userData) async {
    await _firestore
        .collection('Users')
        .doc(_user.uid)
        .update(userData.toJson());
  }
}
