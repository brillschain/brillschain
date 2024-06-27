import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supplink/models/message_model.dart';
import 'package:supplink/models/user_model.dart';

class FirebaseProvider extends ChangeNotifier {
  List<UserData> users = [];
  UserData? user;
  List<Message> messages = [];
  ScrollController scrollController = ScrollController();

  List<UserData> getAllUsers() {
    // print("get all users method");
    FirebaseFirestore.instance
        .collection('Users')
        .orderBy('lastseen', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((users) {
      this.users = users.docs.map((doc) => UserData.fromSnapshot(doc)).toList();
      notifyListeners();
    });
    return users;
  }

  UserData? getUserById(String userId) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
      this.user = UserData.fromSnapshot(user);
      notifyListeners();
    });
    return user;
  }

  List<Message> getMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection('Users')
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
