import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class Firestore {
  // Future<void> createMembers(String manufacturer_uid, List members) async{
  //   CollectionReference users = FirebaseFirestore.instance.collection('Lanes');

  //   return users.doc(manufacturer_uid).set({
  //     'members' : members
  //   })
  //   .then((value) => print("User added successfully!"))
  //   .catchError((error) => print("Failed to add user: $error"));
  // }

  Future<String> getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('AllUsers')
        .doc(user?.uid)
        .get();
    return documentSnapshot.get('name');
  }

  Future<Map<String, dynamic>> getAllUsersInDomains(String domain) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('DomainWiseUsers')
        .doc(domain)
        .get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return data;
  }

  Future<void> AddUsersInDomaines(
      String user_id, String domain, String username) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('DomainWiseUsers');

    try {
      QuerySnapshot querySnapshot = await users.get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        print(document.id);
        if (document.id == domain) {
          users
              .doc(domain)
              .update({user_id: username})
              .then((value) => print("User email updated successfully!"))
              .catchError(
                  (error) => print("Failed to update user email: $error"));
          return;
        }
      }

      users
          .doc(domain)
          .set({user_id: username})
          .then((value) => print("User email updated successfully!"))
          .catchError((error) => print("Failed to update user email: $error"));
    } catch (e) {
      print('Error listing documents: $e');
    }

    return;
  }

  Future<void> addUser(String authid, String name, String email, int location,
      int phoneno, String domain, context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('AllUsers');
    return users
        .doc(authid)
        .set({
          'Auth_id': authid,
          'Email': email,
          'Phone': phoneno,
          'Location': location,
          'Domain': domain,
          'Name': name
        })
        .then((value) => print("User added successfully!"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<Map<String, dynamic>?> fetchCurrentUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    final collectionRef = FirebaseFirestore.instance.collection('AllUsers');
    try {
      final documentSnapshot = await collectionRef.doc(user?.uid).get();
      // print(documentSnapshot.data());
      return documentSnapshot.data();
    } catch (error) {
      print('Error retrieving document: $error');
      return null;
    }
  }
}
