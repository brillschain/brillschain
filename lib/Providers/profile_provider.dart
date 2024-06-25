import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User _user = FirebaseAuth.instance.currentUser!;
  List<int>? _posts;
  // List<String>? _connections;
  List<int>? get posts => _posts;
  // List<String>? get connections => _connections;
  void getPosts() async {
    var res =
        _firestore.collection('posts').where('uid', isEqualTo: _user.uid).get();
    notifyListeners();
  }
}
