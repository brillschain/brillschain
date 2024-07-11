import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supplink/models/message_model.dart';
import 'package:supplink/models/user_model.dart';

class FirebaseProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<UserData> _users = [];
  List<UserData> _allUsers = [];
  List<UserData> get users => _users;
  UserData? user;
  List<Message> messages = [];
  ScrollController scrollController = ScrollController();

  List<UserData> getAllUsers() {
    // print("get all users method");
    _firestore
        .collection('Users')
        .orderBy('lastseen', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((users) {
      _users = users.docs.map((doc) => UserData.fromSnapshot(doc)).toList();
      _allUsers = _users;
      notifyListeners();
    });
    return users;
  }

  UserData? getUserById(String userId) {
    _firestore
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
    _firestore
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

  Future<List<UserData>> searchUser(String name) async {
    _firestore
        .collection('Users')
        .where("name", isGreaterThanOrEqualTo: name)
        .snapshots(includeMetadataChanges: true)
        .listen((users) {
      _users = users.docs.map((doc) => UserData.fromSnapshot(doc)).toList();
      notifyListeners();
    });
    return users;
    // return snapshot.docs.map((doc) => UserData.fromSnapshot(doc)).toList();
  }

  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });

  void onSearch(String? search) {
    // _allUsers = users;

    if (search!.isEmpty) {
      _users = _allUsers;
    }
    _users = _allUsers
        .where((user) => user.name.toLowerCase().contains(search.toLowerCase()))
        .toList();
    notifyListeners();
  }
}


//  assignPropertySearchController.addListener(() {
//       if (assignPropertySearchController.text.isEmpty) {
//         viewModel.propertyNames = viewModel.properties;
//       } else {
//         viewModel.propertyNames = (viewModel.properties.where((property) =>
//             property.toLowerCase().contains(
//                 assignPropertySearchController.text.toLowerCase()))).toList();
//       }
//       viewModel.rebuildUi();
//     });
