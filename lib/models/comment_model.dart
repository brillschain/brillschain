import 'package:cloud_firestore/cloud_firestore.dart';

class CommentData {
  final String username;
  final String uid;
  final String profileUrl;
  final String commentText;
  final String commentId;
  final DateTime timestamp;
  final List likes;

  CommentData(
      {required this.username,
      required this.uid,
      required this.profileUrl,
      required this.commentText,
      required this.commentId,
      required this.likes,
      required this.timestamp});

  Map<String, dynamic> toJson() => {
        'username': username,
        'profileUrl': profileUrl,
        'commentText': commentText,
        'userId': uid,
        'commentId': commentId,
        'timestamp': DateTime.now(),
        'likes': []
      };
  static CommentData fromSnapshot(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return CommentData(
        username: snapshot['username'],
        uid: snapshot['userId'],
        profileUrl: snapshot['profileUrl'],
        commentText: snapshot['commentText'],
        commentId: snapshot['commentId'],
        timestamp: snapshot['timestamp'],
        likes: snapshot['likes']);
  }
}
