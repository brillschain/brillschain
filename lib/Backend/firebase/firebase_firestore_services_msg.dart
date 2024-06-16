import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supplink/Backend/firebase/users.dart';
// import 'package:supplink/Home/messages/messages.dart';
import 'package:supplink/models/message_model.dart';
import 'package:supplink/models/user_model.dart';

// import '../../Home/drawer_pages/connectionsFolder/messages/messages.dart';
// import '../model/message.dart';
// import '../model/user.dart';
// import 'firebase_storage_service.dart';

class FirebaseFirestoreServiceMessages {
  static final firestore = FirebaseFirestore.instance;

  // static Future<void> createUser({
  //   required String name,
  //   required String image,
  //   required String email,
  //   required String uid,
  // }) async {
  //   final user = User_Details(
  //     uid: uid,
  //     email: email,
  //     name: name,
  //     image: image,
  //     isonline: true,
  //     lastseen: DateTime.now(),
  //   );

  //   await FirebaseFirestore.instance
  //       .collection('Messages')
  //       .doc(uid)
  //       .set(user.toJson());
  // }

  static Future<void> addTextMessage({
    required String content,
    required String receiverId,
  }) async {
    final message = Message(
      content: content,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.text,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    await _addMessageToChat(receiverId, message);
  }

  static Future<void> addImageMessage({
    required String receiverId,
    required Uint8List file,
  }) async {
    final image = await FirebaseStorageService.uploadImage(
        file, 'image/chat/${DateTime.now()}');

    final message = Message(
      content: image,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.image,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    await _addMessageToChat(receiverId, message);
  }

  static Future<void> _addMessageToChat(
    String receiverId,
    Message message,
  ) async {
    await firestore
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());

    await firestore
        .collection('Users')
        .doc(receiverId)
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .add(message.toJson());
  }

  static Future<void> updateUserData(Map<String, dynamic> data) async =>
      await firestore
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);

  static Future<List<UserData>> searchUser(String name) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where("name", isGreaterThanOrEqualTo: name)
        .get();

    return snapshot.docs.map((doc) => UserData.fromSnapshot(doc)).toList();
  }
}

class FirebaseStorageService {
  static Future<String> uploadImage(Uint8List file, String storagePath) async =>
      await FirebaseStorage.instance
          .ref()
          .child(storagePath)
          .putData(file)
          .then((task) => task.ref.getDownloadURL());
}

class MediaService {
  static Future<Uint8List?> pickImage() async {
    try {
      final imagePicker = ImagePicker();
      final file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        return await file.readAsBytes();
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
    return null;
  }

  static Future<void> updateUserData(Map<String, dynamic> data) async =>
      await FirebaseFirestore.instance
          .collection('Messages')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);
}
