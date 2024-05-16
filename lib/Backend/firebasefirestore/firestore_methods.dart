import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplink/models/user_model.dart';

class FireBaseFireStoreMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> addUserData(UserData userData) async {
    String res = "failed to signUp try again";
    try {
      await _firestore
          .collection('Users')
          .doc(userData.uid)
          .set(userData.toJson());
      res = " signup successful";
    } catch (e) {
      res = e.toString();
      // print(e.toString());
    }
    return res;
  }

  Future<UserData> getUserData() async {
    User user = _firebaseAuth.currentUser!;
    UserData? userData;
    try {
      print('current user ${user.displayName}');
      DocumentSnapshot snap =
          await _firestore.collection("Users").doc(user.uid).get();
      userData = UserData.fromSnapshot(snap);
    } catch (e) {
      print('get user details');
      print(e.toString());
    }
    return userData!;
  }
}
