import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplink/Backend/firebasefirestore/firestore_methods.dart';

class PostProvider extends ChangeNotifier {
  int? _commentsLength;
  late bool _isConnection;
  // bool isCurrentUser = false;
  String? _res;
  final User user = FirebaseAuth.instance.currentUser!;

  // void init({required String postId, required String anotherUserId}) {
  //   getAllComments(postId);
  //   fetchIsConnection(anotherUserId);
  // }
  int get getCommentLength => _commentsLength ?? 0;
  bool get isConnection => _isConnection;
  String get response => _res!;
  Future<void> getAllComments(String postId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      _commentsLength = querySnapshot.docs.length;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchIsConnection(String anotherUserId) async {
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(anotherUserId)
          .get();

      var ids = usersnap.data()!['connections'] ?? [];
      _isConnection = ids.contains(user.uid);
      // if (_isConnection) {
      //   res = " removed from your connections";
      // } else {
      //   res = " added to your connections";
      // }
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> manageConnection(String anotherUserId) async {
    try {
      if (_isConnection) {
        await FireBaseFireStoreMethods().connectUser(user.uid, anotherUserId);
        _res = " removed from your connections";
        _isConnection = false;

        notifyListeners();
      } else {
        await FireBaseFireStoreMethods().connectUser(user.uid, anotherUserId);
        _res = " added to your connections";
        _isConnection = true;

        notifyListeners();
      }
    } catch (e) {
      _res = e.toString();
    }
    // return _res!;
  }

  // Future<String> addConnection(String anotherUserId) async {
  //   String res = '';
  //   try {
  //     await FireBaseFireStoreMethods().connectUser(user.uid, anotherUserId);
  //     isConnection = true;

  //     res = "Connection added";
  //     notifyListeners();
  //   } catch (e) {
  //     res = e.toString();
  //   }
  //   return res;
  // }

  // Future<String> removeConnection(String anotherUserId) async {
  //   String res = '';
  //   try {
  //     await FireBaseFireStoreMethods().connectUser(user.uid, anotherUserId);
  //     isConnection = false;

  //     res = "Connection removed";
  //     notifyListeners();
  //   } catch (e) {
  //     res = e.toString();
  //   }
  //   return res;
  // }
}
