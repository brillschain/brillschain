import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supplink/models/user_model.dart';
import 'package:supplink/utils/image_picker.dart';
import 'package:supplink/utils/snackbars.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserData? userData;
  Uint8List? pickedImage;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('Users').doc(widget.uid).get();

      setState(() {
        userData = UserData.fromSnapshot(snapshot);
        isLoading = false;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Username"),
              centerTitle: false,
            ),
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              pickedImage != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          MemoryImage(pickedImage!),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(userData!.profileUrl),
                                    ),
                              Positioned(
                                  // top: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await _selectImage(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 4, color: Colors.white),
                                          color: Colors.blue[200]),
                                      child: const Icon(Icons.edit),
                                    ),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                      text: userData!.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      )),
                                  TextSpan(
                                      text: userData!.domain,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      )),
                                  TextSpan(
                                      text: userData!.address,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      )),
                                  TextSpan(
                                      text: userData!.phoneno.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      )),
                                  const TextSpan(
                                      text: "About",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      )),
                                ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  _selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('select image from'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    pickedImage = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallary'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    pickedImage = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('cancel'),
              )
            ],
          );
        });
  }
}
