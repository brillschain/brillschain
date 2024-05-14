import 'dart:convert';
// import 'dart:js_interop';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:path/path.dart';
// import 'package:supabase/supabase.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseCredentials.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseServices/Strorages/connectionsUrlManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:supplink/Authentication/signup.dart';

class UserDetailsTable {
  late GeoPoint geoPoint;

  Future<String> generateUserId(String userName) async {
    //Todo all users id set are here, make sure it.
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('AllUsers').get();

    Set<String> userIdsSet = {};

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> m = doc.data() as Map<String, dynamic>;

      String userId = m['User_id'] ?? '';
      if (userId.isNotEmpty) {
        userIdsSet.add(userId);
      }
    });

    String baseUserId =
        userName.toLowerCase().replaceAll(' ', '') + getRandomNumberString(3);
    String newUserId = baseUserId;

    int suffix = 1;
    while (userIdsSet.contains(newUserId)) {
      newUserId = baseUserId + (suffix++).toString();
    }
    return newUserId;
  }

  String getRandomNumberString(int length) {
    String charSet = '0123456789';
    String result = '';
    final random = Random();
    for (int i = 0; i < length; i++) {
      result += charSet[random.nextInt(charSet.length)];
    }
    return result;
  }

  Future<void> addUser(
      String authid,
      String name,
      String email,
      int location,
      int phoneno,
      String domain,
      String village,
      context,
      String user_id) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('AllUsers');
    try {
      FetchLocation fetchLocation = FetchLocation();
      final List coordinates = await fetchLocation.getCordinates(location);
      geoPoint = GeoPoint(coordinates[0], coordinates[1]);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('invalid pin code')));
    }
    // print('users collection');
    return users
        .doc(authid)
        .set({
          'Auth_id': authid,
          'Email': email,
          'Phone': phoneno,
          'Location': geoPoint,
          'Domain': domain,
          'Name': name,
          'Village': village,
          'Pincode': location,
          'User_id': user_id
        })
        .then((value) => print("User added successfully!"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addPosts(
      String authid, String posturl, String description) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('AllUsers');
    CollectionReference posts = users.doc(authid).collection('Posts');
    // int numberOfPosts = await posts.get().then((value) => value.docs.length);
    // String nextPostId = 'post${numberOfPosts + 1}';
    return posts
        .doc()
        .set({
          'Auth_id': authid,
          'posturl': posturl,
          'Description': description,
          'Time': Timestamp.now()
        })
        .then((value) => print("Post added successfully!"))
        .catchError((error) => print("Failed to add Post: $error"));
  }

  Future<void> addprofile(String authid, String profileurl) {
    // print('adding the profile ');
    CollectionReference users =
        FirebaseFirestore.instance.collection('AllUsers');
    CollectionReference posts = users.doc(authid).collection('Profile');
    return posts
        .doc('Profile')
        .set({
          'Auth_id': authid,
          'Profileurl': profileurl,
        })
        .then((value) => print("Profile added successfully!"))
        .catchError((error) => print("Failed to add Profile: $error"));
  }

  Future<void> addFollowers(
      String currenuserAuthid, String tobefollowerid, String tobefollowername) {
    // print('adding the profile ');
    CollectionReference users =
        FirebaseFirestore.instance.collection('AllUsers');
    CollectionReference followers =
        users.doc(currenuserAuthid).collection('Followers');
    return followers
        .doc(tobefollowerid)
        .set({
          'name': tobefollowername,
        })
        .then((value) => print("Profile added successfully!"))
        .catchError((error) => print("Failed to add Profile: $error"));
  }

  Future<bool> checkFollower(String currenuserAuthid, String followerid) async {
    // print('adding the profile ');
    CollectionReference users =
        FirebaseFirestore.instance.collection('AllUsers');
    CollectionReference followers =
        users.doc(currenuserAuthid).collection('Followers');
    QuerySnapshot userPostsSnapshot = await followers.get();

    for (QueryDocumentSnapshot followerdoc in userPostsSnapshot.docs) {
      if (followerdoc.id == followerid) {
        return true;
      }
    }
    return false;
    // return
  }

  Future<void> deleteFollower(
      String currenuserAuthid, String followerid) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('AllUsers');
    CollectionReference followers =
        users.doc(currenuserAuthid).collection('Followers');
    QuerySnapshot userPostsSnapshot = await followers.get();

    for (QueryDocumentSnapshot followerdoc in userPostsSnapshot.docs) {
      if (followerdoc.id == followerid) {
        followerdoc.reference.delete();
      }
    }
  }

  Future<Map<String, dynamic>?> fetchCurrentUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    final collectionRef = FirebaseFirestore.instance.collection('AllUsers');
    // print('get Specific Document called');
    try {
      final documentSnapshot = await collectionRef.doc(user?.uid).get();
      // print(documentSnapshot.data());
      return documentSnapshot.data();
    } catch (error) {
      print('Error retrieving current user: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchprofileurl({String Auth_id = ''}) async {
    String user =
        Auth_id == '' ? FirebaseAuth.instance.currentUser!.uid : Auth_id;

    CollectionReference users =
        FirebaseFirestore.instance.collection('AllUsers');
    CollectionReference profileurlRef = users.doc(user).collection('Profile');
    try {
      final profilesnapshot = await profileurlRef.doc('Profile').get();

      return profilesnapshot.data() as Map<String, dynamic>?;
    } catch (error) {
      print('Error retrieving profile: $error');
      return null;
    }
  }

  Future<List<CurrentUserPostDetails>> fetchUserPosts() async {
    final user = FirebaseAuth.instance.currentUser;

    List<CurrentUserPostDetails> userPostList = [];
    String profile = '';
    try {
      CollectionReference allUsersCollection =
          FirebaseFirestore.instance.collection('AllUsers');
      DocumentReference currentUserDoc = allUsersCollection.doc(user?.uid);
      CollectionReference userPostsCollection =
          currentUserDoc.collection('Posts');
      CollectionReference userProfileCollection =
          currentUserDoc.collection('Profile');

      QuerySnapshot userPostsSnapshot = await userPostsCollection.get();
      QuerySnapshot userProfileSnapshot = await userProfileCollection.get();

      if (userProfileSnapshot.docs.isNotEmpty) {
        final urlData = userProfileSnapshot.docs.first.data();
        if (urlData != null) {
          final url = urlData as Map<String, dynamic>;
          profile = url['Profileurl'] as String? ?? '';
        } else {
          print('no profile ');
          profile = '';
        }
      }

      final documentSnapshot = await currentUserDoc.get();
      Map<String, dynamic> details =
          documentSnapshot.data() as Map<String, dynamic>? ?? {};

      userPostList = userPostsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Timestamp timestamp = data['Time'];
        DateTime postDateTime = timestamp.toDate();
        String formattedDate = DateFormat('MMMM d').format(postDateTime);

        return CurrentUserPostDetails(
          name: details['Name'] ?? '',
          address: details['Village'] ?? '',
          profile: profile,
          statement: data['Description'] ?? '',
          // type: data['Type'] ?? '',
          posturl: data['posturl'] ?? '',
          phoneno: (details['Phone'] ?? 0).toString(),
          postDate: formattedDate,
        );
      }).toList();
    } catch (error) {
      print('Error fetching user posts: $error');
    }
    print('post extracted');
    // print(userPostList);
    return userPostList;
  }

  Future<Map<String, dynamic>> getAllUsersInDomains(String domain) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
        await firestore.collection('DomainWiseUsers').doc(domain).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return data;
  }

  Future<void> addUsersInDomaines(
      String user_id, String domain, String username) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('DomainWiseUsers');

    try {
      QuerySnapshot querySnapshot = await users.get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        // print(document.id);
        if (document.id == domain) {
          return users
              .doc(domain)
              .update({user_id: username})
              .then((value) => print("User email updated successfully!"))
              .catchError(
                  (error) => print("Failed to update user email: $error"));
        }
      }

      return users
          .doc(domain)
          .set({user_id: username})
          .then((value) => print("User email updated successfully!"))
          .catchError((error) => print("Failed to update user email: $error"));
    } catch (e) {
      print('Error listing documents: $e');
    }

    return;
  }
}

class CurrentUserPostDetails {
  final String name;
  final String address;
  final String profile;
  final String statement;
  // final String type;
  final String posturl;
  final String phoneno;
  final String postDate;

  CurrentUserPostDetails({
    required this.name,
    required this.address,
    required this.profile,
    required this.statement,
    // required this.type,
    required this.posturl,
    required this.phoneno,
    required this.postDate,
  });
}

//function to fetch the latlon using pincode from the api(api at to complete)
class FetchLocation {
  Future<List> getCordinates(int loc_pin) async {
    Map<String, dynamic> json_data = {'pin': loc_pin as int};

    String jsonData = jsonEncode(json_data);

    final http.Response response = await http.post(
      Uri.parse('http://127.0.0.1:5001/api/post_pin'),
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    );
    Map<String, dynamic> coordinates = json.decode(response.body);
    print(coordinates);
    //"{'latitude':45.45544, 'longitute':73.45553}"
    List cors = [coordinates['latitude'], coordinates['longitude']];
    return cors;
  }
}
