// import 'package:flutter/material.dart';
import 'package:supplink/Backend/firebase/firebase_firestore_services_msg.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseCredentials.dart';
// import 'package:supabase/supabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseServices/Tables/firebase_firestore_services_msg.dart';

class AuthenticationService {
  late User _user;

  Future<dynamic> signupp({
    required String email,
    required String password,
    required String displayName,
    // required String phoneNumber,
  }) async {
    try {
      // print('object');
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(displayName);
      // await credential.user!.updatePhoneNumber(phoneNumber as PhoneAuthCredential);
      print('firebase cred');
      print(credential);
      _user = credential.user!;

      return ['signup', _user.uid];
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return ['error', 'The account already exists for that email.'];
      } else {
        // print('jidfsudf');
        print(e);
        return ['error', 'An error occurred during signup.'];
      }
    }
  }

  // Future<User?> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   final response = await SupabaseCreds.supabaseClient.auth
  //       .signInWithPassword(email: email, password: password);
  //   final Session? session = response.session;
  //   final User? _user = response.user;
  //   print(_user?.id);
  //   print(_user?.email);
  //   print(_user);
  //   return getUser();
  // }

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _user = credential.user!;
      await FirebaseFirestoreServiceMessages.updateUserData(
        {'lastseen': DateTime.now()},
      );
      // print(_user);
      return _user;
    } on FirebaseAuthException catch (e) {
      // Handle specific error cases
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print('Error: ${e.message}');
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Future sendVerificationCode({
  //   required String phoneNumber,
  //   required BuildContext context,
  // }) async {
  //   try {
  //     final response = await SupabaseCreds.supabaseClient.auth.signInWithOtp(
  //       phone: phoneNumber,
  //       // options: {
  //       //   'redirectTo': SupabaseCredentials.APIURL,
  //       //   'provider': 'phone', // Add this option
  //       // },
  //     );
  //     print('signInWithOtp function output');
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(e.toString())));
  //   }
  // }

  // Future<bool?> verifyPhoneNumber({
  //   required String phone,
  //   required String token,
  //   required BuildContext context,
  //   required OtpType type,
  // }) async {
  //   try {
  //     final response = await SupabaseCreds.supabaseClient.auth.verifyOTP(
  //       phone: phone,
  //       token: token,
  //       type: type,
  //     );
  //     print('verified with number ${phone}');
  //     return true;
  //   } catch (e) {
  //     print('not verfied. Invalid Otp Creds');
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(e.toString())));
  //     return false;
  //   }
  // }

  List<String> authExceptionHandler(Object e) {
    String message = e.toString();
    List mess = message.split(',');
    String error = mess[0].substring(23);
    String statusCode = mess[1].split(':')[1].substring(0, 4);
    return [error, statusCode];
  }
}
