import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplink/Backend/firebasefirestore/firestore_methods.dart';

class PostProvider extends ChangeNotifier {
  int commentsLength = 0;
  bool isConnection = false;
  bool isCurrentUser = false;
  final User user = FirebaseAuth.instance.currentUser!;

  void init({required String postId, required String anotherUserId}) {
    getAllComments(postId);
    fetchIsConnection(anotherUserId);
  }

  Future<void> getAllComments(String postId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      commentsLength = querySnapshot.docs.length;
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
      isConnection = ids.contains(user.uid);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> manageConnection(String anotherUserId) async {
    String res = "";
    try {
      if (!isConnection) {
        await FireBaseFireStoreMethods().connectUser(user.uid, anotherUserId);
        isConnection = true;

        res = "Connection added";
        notifyListeners();
      } else {
        await FireBaseFireStoreMethods().connectUser(user.uid, anotherUserId);
        isConnection = false;

        res = "Connection removed";
        notifyListeners();
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> addConnection(String anotherUserId) async {
    String res = '';
    try {
      await FireBaseFireStoreMethods().connectUser(user.uid, anotherUserId);
      isConnection = true;

      res = "Connection added";
      notifyListeners();
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> removeConnection(String anotherUserId) async {
    String res = '';
    try {
      await FireBaseFireStoreMethods().connectUser(user.uid, anotherUserId);
      isConnection = false;

      res = "Connection removed";
      notifyListeners();
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
