import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supplink/Backend/storage/firebase_storage_.dart';
import 'package:supplink/models/comment_model.dart';
import 'package:supplink/models/post_model.dart';
import 'package:uuid/uuid.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class FireStorePostMethods {
  // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //post upload to firebase _firestore.
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String address, String profileUrl, String name) async {
    String res = "error in uploading";
    try {
      String postUrl =
          await StorageMethods().uploadImageToStorage(file, true, 'posts');
      String postId = const Uuid().v1();
      PostData postData = PostData(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: postUrl,
          likes: [],
          name: name,
          address: address,
          profileUrl: profileUrl);
      await _firestore.collection('posts').doc(postId).set(postData.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //likes tracker

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //comments upload
  Future<String> postComments(String postId, String commentText, String uid,
      String profileUrl, String username) async {
    String res = "error in comment upload";
    try {
      if (commentText.isNotEmpty) {
        String commentId = const Uuid().v1();
        CommentData commentData = CommentData(
            username: username,
            uid: uid,
            profileUrl: profileUrl,
            commentText: commentText,
            commentId: commentId,
            timestamp: DateTime.now());
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(commentData.toJson());
        res = 'succcess';
      } else {
        res = 'check comment once';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //post deleting
  Future<String> deletePost(String postId, BuildContext context) async {
    String res = "Try again";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = "post deleted";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
