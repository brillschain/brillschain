import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  final String uid;
  final String name;
  final String email;
  final GeoPoint coordinates;
  final String profileUrl;
  final String domain;
  final String address;
  final int phoneno;
  final int pincode;
  final String username;
  final List following;
  final List followers;

  UserDetails({
    required this.uid,
    required this.name,
    required this.email,
    required this.coordinates,
    required this.profileUrl,
    required this.domain,
    required this.address,
    required this.phoneno,
    required this.username,
    required this.following,
    required this.followers,
    required this.pincode,
  });

  Map<String, dynamic> toJson() => {
        'Auth_id': uid,
        'Email': email,
        'Phone': phoneno,
        'Location': coordinates,
        'Domain': domain,
        'Name': name,
        'ProfileUrl': profileUrl,
        'Village': address,
        'Pincode': pincode,
        'User_id': username,
        'following': following,
        'followers': followers,
      };
}
