import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:supplink/Backend/firebasefirestore/firestore_methods.dart';

import 'package:supplink/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserData? _userData;
  UserData get getUser => _userData!;
  Future<void> refreshUserData() async {
    try {
      UserData userData = await FireBaseFireStoreMethods().getUserData();
      _userData = userData;
    } catch (e) {
      print("error in provider ${e.toString()}");
    }
    notifyListeners();
  }
}
