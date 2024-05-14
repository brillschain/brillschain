// import 'dart:io';
import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:path/path.dart';
import 'package:supplink/Backend/firebase/userDeatilsmaintain.dart';

class ImageUploads extends StatefulWidget {
  ImageUploads({Key? key}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    descriptionController = TextEditingController();
    super.initState();
  }

  Uint8List? imageBytes;
  var uploadedPhotoUrl = '';
  final ImagePicker _picker = ImagePicker();
  String description = '';

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    print('picked image');
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        imageBytes = bytes;
        // uploadFile();
      });
    } else {
      print('No image selected.');
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        imageBytes = bytes;
        // uploadFile();
      });
    } else {
      print('No image selected.');
    }
  }

  Future uploadFile(BuildContext context) async {
    UserDetailsTable userDetailsTable = UserDetailsTable();
    Map<String, dynamic>? current_user =
        await userDetailsTable.fetchCurrentUserDetails();
    print('uploading function');
    if (imageBytes == null) return;
    final uid = current_user!['Auth_id'];
    // final destination = 'Posts/$uid';
    final destination = 'Posts/$uid/Media/';

    try {
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref(destination);
      int numberOfImages =
          await ref.listAll().then((result) => result.items.length);
      await ref
          .child('post${numberOfImages + 1}.jpg')
          .putData(imageBytes!, SettableMetadata(contentType: 'image/jpeg'))
          .whenComplete(() async {
        await ref
            .child('post${numberOfImages + 1}.jpg')
            .getDownloadURL()
            .then((value) {
          setState(() {
            uploadedPhotoUrl = value;
            userDetailsTable.addPosts(uid, uploadedPhotoUrl, description);
          });
        });
        await ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('post uploaded')));
      });
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(uploadedPhotoUrl);
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: 350,
                    height: 250,
                    color: Colors.grey[300],
                    child: imageBytes != null
                        ? Image.memory(
                            imageBytes!,
                            fit: BoxFit.cover,
                          )
                        : GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          )),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 400,
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Description',
                contentPadding: EdgeInsets.only(left: 5),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: () async {
                description = descriptionController.text;
                if (imageBytes != null) {
                  uploadFile(context);
                }
              },
              child: Text('Upload'))
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: imgFromGallery,
            tooltip: 'Pick Image from gallery',
            child: Icon(Icons.photo_library),
          ),
          SizedBox(
            height: 16,
          ),
          FloatingActionButton(
            onPressed: imgFromCamera,
            tooltip: 'Take a photo',
            child: Icon(Icons.photo_camera),
          ),
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
