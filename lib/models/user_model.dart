import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
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
  final List connections;
  final DateTime lastseen;
  final bool isonline;

  UserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.coordinates,
    required this.profileUrl,
    required this.domain,
    required this.address,
    required this.phoneno,
    required this.username,
    required this.connections,
    required this.lastseen,
    this.isonline = false,
    required this.pincode,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'phoneno': phoneno,
        'coordinates': coordinates,
        'domain': domain,
        'name': name,
        'profileUrl': profileUrl,
        'address': address,
        'pincode': pincode,
        'username': username,
        'connections': connections,
        "isonline": isonline,
        "lastseen": lastseen,
      };

  static UserData fromSnapshot(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    // print(1);
    return UserData(
        uid: snapshot['uid'],
        name: snapshot['name'],
        email: snapshot['email'],
        coordinates: snapshot['coordinates'],
        profileUrl: snapshot['profileUrl'] ?? "",
        domain: snapshot['domain'],
        address: snapshot['address'],
        phoneno: snapshot['phoneno'],
        username: snapshot['username'] ?? "",
        connections: snapshot['connections'] ?? [],
        lastseen: (snapshot['lastseen'] as Timestamp).toDate(),
        isonline: snapshot['isOnline'] ?? false,
        pincode: snapshot['pincode']);
  }
}
