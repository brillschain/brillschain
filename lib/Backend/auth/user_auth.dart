import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplink/Backend/firebasefirestore/firestore_methods.dart';
import 'package:supplink/models/user_model.dart';
// import 'package:supplink/utils/snackbars.dart';

import '../firebase/userDetailsmaintain.dart';

class UserAuthentication {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late GeoPoint geoPoint;
  FireBaseFireStoreMethods fireBaseFireStoreMethods =
      FireBaseFireStoreMethods();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserDetailsTable userdetails = UserDetailsTable();

  Future<String> signUpUser({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String domain,
    required String address,
    required int phoneno,
    required String username,
    required int pincode,
  }) async {
    String res = "some error occured";
    try {
      FetchLocation fetchLocation = FetchLocation();
      final List coordinates = await fetchLocation.getCordinates(pincode);
      geoPoint = GeoPoint(coordinates[0], coordinates[1]);
    } catch (e) {
      res = "Invalid pin code";
    }
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          !geoPoint.latitude.isNaN &&
          domain.isNotEmpty) {
        UserCredential credential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await credential.user!.updateDisplayName(name);
        String uid = credential.user!.uid;
        UserData userData = UserData(
            uid: uid,
            name: name,
            email: email,
            coordinates: geoPoint,
            profileUrl:
                'https://as2.ftcdn.net/v2/jpg/02/15/84/43/1000_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg',
            domain: domain,
            address: address,
            phoneno: phoneno,
            username: username,
            following: [],
            followers: [],
            pincode: pincode);
        await _firestore
            .collection('Users')
            .doc(userData.uid)
            .set(userData.toJson());
        res = "success";
        userdetails.addUsersInDomaines(uid, domain, username);
      } else {
        res = "please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
      } else if (e.code == "invalid-email") {
        res = "Email is Badly Formated";
      } else {
        res = e.message.toString();
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error has occured";
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      res = 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        res = 'Invalid Password ';
      } else if (e.message.toString() ==
          "The supplied auth credential is incorrect, malformed or has expired.") {
        res = "Invalid credential";
      } else {
        res = e.message.toString();
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
