// import 'package:flutter/material.dart';

// import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
// // import 'package:gotrue/src/types/provider.dart' hide Provider;
// import 'package:provider/provider.dart';
// import 'package:supplink/Providers/core/notifiers/authenticationnotifier.dart';
// import 'package:supplink/Authentication/authRoutes/AppRoutes.dart';

// class PhoneNumberAuthView extends StatefulWidget {
//   const PhoneNumberAuthView({super.key});

//   @override
//   State<PhoneNumberAuthView> createState() => _PhoneNumberAuthViewState();
// }

// class _PhoneNumberAuthViewState extends State<PhoneNumberAuthView> {
//   TextEditingController phoneNumberController = TextEditingController();
//   TextEditingController otpController = TextEditingController();
//   // TextEditingController typeController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final Authenticationotifier authenticationNotifier =
//         Provider.of<Authenticationotifier>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("phone view"),
//       ),
//       body: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             TextField(
//               controller: phoneNumberController,
//               decoration: InputDecoration(hintText: "enter phone number"),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             TextField(
//               controller: otpController,
//               decoration: InputDecoration(hintText: "enter otp"),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             ElevatedButton(
//                 onPressed: () async {
//                   authenticationNotifier.sendVerificationCode(
//                       context: context,
//                       phoneNumber: phoneNumberController.text);
//                 },
//                 child: Text("send verification code")),
//             SizedBox(
//               height: 10,
//             ),
//             ElevatedButton(
//                 onPressed: () async {
//                   // authenticationNotifier.verifyPhoneNumber(
//                   //     context: context,
//                   //     phoneNumber: phoneNumberController.text,
//                   //     token: otpController.text,
//                   //     type: OtpType.phoneChange);
//                   // bool? response =
//                   //     await authenticationNotifier.verifyPhoneNumber(
//                   //         context: context,
//                   //         phoneNumber: phoneNumberController.text,
//                   //         token: otpController.text,
//                   //         type: OtpType.phoneChange);
//                   bool? response;
//                   // try {
//                   //   response = await authenticationNotifier.verifyPhoneNumber(
//                   //     context: context,
//                   //     phoneNumber: phoneNumberController.text,
//                   //     token: otpController.text,
//                   //     type: OtpType.sms,
//                   //   );
//                   //   if (response == true) {
//                   //     Navigator.of(context).pushNamed(AppRoutes.Myhomepage);
//                   //   }
//                   // } catch (e) {
//                   //   ScaffoldMessenger.of(context)
//                   //       .showSnackBar(SnackBar(content: Text(e.toString())));
//                   // }
//                 },
//                 child: Text("verify phonenumber")),
//           ],
//         ),
//       ),
//     );
//   }
// }
