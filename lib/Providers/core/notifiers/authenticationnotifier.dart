import 'package:flutter/material.dart';
// import 'package:provider/single_child_widget.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supplink/Routes/Routes.dart';
import 'package:supplink/Backend/firebase/fireBaseAuth.dart/authenticationService.dart';

class Authenticationotifier extends ChangeNotifier {
  final AuthenticationService _authenticationService =
      new AuthenticationService();

  Future<dynamic> signup(
      {required String email,
      required String password,
      required String confirmpassword,
      required String displayName}) async {
    print('signing using firebase');
    if (confirmpassword == password) {
      return await _authenticationService.signupp(
          email: email, password: password, displayName: displayName);
    } else {
      return ["Password and confirm password doesn't match", null];
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final user =
          await _authenticationService.login(email: email, password: password);
      // Navigator.of(context).pushNamed(AppRoutes.Myhomepage);
      // print('Login succesfully');
      if (user != null) {
        // Navigate to the homepage
        Navigator.of(context).pushNamed(AppRoutes.Myhomepage);
        print('Login successful');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email or password'),
          ),
        );
        print('Login failed');
      }
    } catch (e) {
      print('Error in authentication service -> login');
      print(e);
    }
  }

  // Future<bool?> sendVerificationCode({
  //   required BuildContext context,
  //   required String phoneNumber,
  // }) async {
  //   try {
  //     await _authenticationService.sendVerificationCode(
  //         context: context, phoneNumber: phoneNumber);
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }

  // Future<bool?> verifyPhoneNumber({
  //   required BuildContext context,
  //   required String phoneNumber,
  //   required String token,
  //   required OtpType type,
  // }) async {
  //   bool? response = false;
  //   try {
  //     response = await _authenticationService.verifyPhoneNumber(
  //         context: context, phone: phoneNumber, token: token, type: type);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(e.toString())));
  //   }
  //   return response;
  // }
}
