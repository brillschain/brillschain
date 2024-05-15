import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:supplink/Backend/firebasefirestore/firestore_methods.dart';

import 'package:supplink/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserData? _userData;
  UserData get getUser => _userData!;
  Future<void> refreshUserData() async {
    UserData userData = await FireBaseFireStoreMethods().getUserData();
    _userData = userData;
    notifyListeners();
  }
}
