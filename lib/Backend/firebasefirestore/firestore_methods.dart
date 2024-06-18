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

    DocumentSnapshot snap =
        await _firestore.collection("Users").doc(user.uid).get();

    return UserData.fromSnapshot(snap);
  }

  Future<List<UserData>> getAllUserData() async {
    List<UserData> allUserData = [];
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Users').get();
      for (QueryDocumentSnapshot userDocs in querySnapshot.docs) {
        allUserData.add(UserData.fromSnapshot(userDocs));
      }
    } catch (e) {
      print(e.toString());
    }
    return allUserData;
  }

  Future<void> connectUser(String currentUserId, String anotherUserId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('Users').doc(currentUserId).get();
      var data = snapshot.data() as Map<String, dynamic>;
      List connection = data['connections'];

      if (connection.contains(anotherUserId)) {
        await _firestore.collection('Users').doc(anotherUserId).update({
          'connections': FieldValue.arrayRemove([currentUserId]),
        });
        await _firestore.collection('Users').doc(currentUserId).update({
          'connections': FieldValue.arrayRemove([anotherUserId]),
        });
      } else {
        await _firestore.collection('Users').doc(anotherUserId).update({
          'connections': FieldValue.arrayUnion([currentUserId]),
        });
        await _firestore.collection('Users').doc(currentUserId).update({
          'connections': FieldValue.arrayUnion([anotherUserId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
