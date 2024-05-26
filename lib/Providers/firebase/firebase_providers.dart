import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supplink/Backend/firebase/users.dart';
import 'package:supplink/Home/messages/messages.dart';

class FirebaseProvider extends ChangeNotifier {
  List<User_Details> users = [];
  User_Details? user;
  List<Message> messages = [];
  ScrollController scrollController = ScrollController();

  List<User_Details> getAllUsers() {
    // print("get all users method");
    FirebaseFirestore.instance
        .collection('Messages')
        .orderBy('lastseen', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((users) {
      this.users =
          users.docs.map((doc) => User_Details.fromJson(doc.data())).toList();
      notifyListeners();
    });
    return users;
  }

  User_Details? getUserById(String userId) {
    FirebaseFirestore.instance
        .collection('Messages')
        .doc(userId)
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
      this.user = User_Details.fromJson(user.data()!);
      notifyListeners();
    });
    return user;
  }

  List<Message> getMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection('Messages')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      this.messages =
          messages.docs.map((doc) => Message.fromJson(doc.data())).toList();
      notifyListeners();

      scrollDown();
    });
    return messages;
  }

  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
}
