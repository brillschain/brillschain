// import 'dart:typed_data';

// import 'package:flutter/material.dart';

// Future<Uint8List> _selectImage(context) async {
//   return await showDialog(
//       context: context,
//       builder: (context) {
//         return SimpleDialog(
//           title: const Text('select image from'),
//           children: [
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Take a photo'),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 Uint8List file = await pickImage(ImageSource.camera);
//                 setState(() {
//                   pickedImage = file;
//                 });
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Choose from gallary'),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 Uint8List file = await pickImage(ImageSource.gallery);
//                 setState(() {
//                   pickedImage = file;
//                 });
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('cancel'),
//             )
//           ],
//         );
//       });
// }
