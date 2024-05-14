import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllPostExtract {
  Future<List<PostDetails>> fetchAllUserPosts() async {
    List<PostDetails> allUserPostList = [];

    try {
      CollectionReference allUsersCollection =
          FirebaseFirestore.instance.collection('AllUsers');

      QuerySnapshot allUsersSnapshot = await allUsersCollection.get();

      for (QueryDocumentSnapshot userDoc in allUsersSnapshot.docs) {
        String userId = userDoc.id;
        String userName = userDoc['Name'] ?? '';
        String userAddress = userDoc['Village'];
        late String profile = '';
        String domain = userDoc['Domain'];

        CollectionReference userPostsCollection =
            allUsersCollection.doc(userId).collection('Posts');
        CollectionReference userProfileCollection =
            allUsersCollection.doc(userId).collection('Profile');

        QuerySnapshot userPostsSnapshot = await userPostsCollection.get();
        QuerySnapshot userProfileSnapshot = await userProfileCollection.get();
        if (userProfileSnapshot.docs.isNotEmpty) {
          final urlData = userProfileSnapshot.docs.first.data();
          if (urlData != null) {
            final url = urlData as Map<String, dynamic>;
            profile = url['Profileurl'] as String? ?? '';
            // print(profile);
          } else {
            print('no profile ');
            profile = '';
          }
        }

        try {
          for (QueryDocumentSnapshot postDoc in userPostsSnapshot.docs) {
            Map<String, dynamic> postData =
                postDoc.data() as Map<String, dynamic>;
            Timestamp timestamp = postData['Time'];
            DateTime postDateTime = timestamp.toDate();
            String formattedDate = DateFormat('MMMM d').format(postDateTime);

            allUserPostList.add(PostDetails(
              uid: userId,
              name: userName,
              address: userAddress,
              profile: profile,
              statement: postData['Description'] ?? '',
              posturl: postData['posturl'] ?? '',
              phoneno: (userDoc['Phone'] ?? 0).toString(),
              postDate: formattedDate,
              domain: domain,
            ));
          }
        } catch (e) {
          print('Error add all user posts: $e');
        }
      }
    } catch (error) {
      print('Error fetching all user posts: $error');
    }

    return allUserPostList;
  }
}

class PostDetails {
  final String name;
  final String address;
  final String profile;
  final String statement;
  // final String type;
  final String posturl;
  final String phoneno;
  final String postDate;
  final String uid;
  final String domain;

  PostDetails({
    required this.name,
    required this.address,
    required this.profile,
    required this.statement,
    // required this.type,
    required this.posturl,
    required this.phoneno,
    required this.postDate,
    required this.domain,
    required this.uid,
  });
}
