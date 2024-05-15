// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  Future<String> uploadImageToStorage(
      Uint8List file, bool isPost, String pathName) async {
    Reference storageRef =
        storage.ref().child(pathName).child(auth.currentUser!.uid);
    if (isPost) {
      String postId = const Uuid().v1();
      storageRef = storageRef.child(postId);
    }
    SettableMetadata metadata =
        SettableMetadata(contentType: 'image/jpeg/jpg/png');
    TaskSnapshot taskSnapshot = await storageRef.putData(file, metadata);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
