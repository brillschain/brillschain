import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:supplink/Backend/firebasefirestore/firestore_methods.dart';

import 'package:supplink/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserData? _userData;
  List<UserData>? _allUserData;
  UserData get getUser => _userData!;
  List<UserData> get getAllUserData => _allUserData!;
  Future<void> refreshUserData() async {
    try {
      UserData userData = await FireBaseFireStoreMethods().getUserData();
      _userData = userData;
    } catch (e) {
      print("error in provider in user data ${e.toString()}");
    }
    notifyListeners();
  }

  Future<void> refreshAllUserData() async {
    try {
      List<UserData> allUserData =
          await FireBaseFireStoreMethods().getAllUserData();
      _allUserData = allUserData;
    } catch (e) {
      print("error in provider in all user data  ${e.toString()}");
    }
    notifyListeners();
  }
}
