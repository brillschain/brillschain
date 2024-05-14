import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class AllUserDetailsExtract {
  Future<List<UserDetails>> fetchAllUserDetails() async {
    List<UserDetails> allUsertList = [];

    try {
      CollectionReference allUsersCollection =
          FirebaseFirestore.instance.collection('AllUsers');

      QuerySnapshot allUsersSnapshot = await allUsersCollection.get();

      for (QueryDocumentSnapshot userDoc in allUsersSnapshot.docs) {
        String userId = userDoc.id;
        String userName = userDoc['Name'] ?? '';
        String userAddress = userDoc['Village'];
        String domain = userDoc['Domain'];
        GeoPoint location = userDoc['Location'];
        String phoneno = (userDoc['Phone'] ?? 0).toString();
        late String profile = '';

        CollectionReference userProfileCollection =
            allUsersCollection.doc(userId).collection('Profile');

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
          allUsertList.add(UserDetails(
            name: userName,
            address: userAddress,
            profile: profile,
            phoneno: phoneno,
            authId: userId,
            domain: domain,
            location: location,
          ));
        } catch (e) {
          print('Error add all user details: $e');
        }
      }
    } catch (error) {
      print('Error fetching all user details: $error');
    }

    return allUsertList;
  }
}

class UserDetails {
  final String authId;
  final String name;
  final String domain;
  final GeoPoint location;
  // final String email;
  final String phoneno;
  final String address;
  final String profile;

  UserDetails({
    required this.authId,
    required this.name,
    required this.domain,
    required this.location,
    // required this.email,
    required this.phoneno,
    required this.address,
    required this.profile,
  });
}
