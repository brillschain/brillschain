// import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supplink/Backend/firebasefirestore/firestore_post_methods.dart';
import 'package:supplink/Providers/user_provider.dart';
import 'package:supplink/models/user_model.dart';
import 'package:supplink/utils/image_picker.dart';
import 'package:supplink/utils/snackbars.dart';

class PostUpload extends StatefulWidget {
  const PostUpload({super.key});

  @override
  State<PostUpload> createState() => _PostUploadState();
}

class _PostUploadState extends State<PostUpload> {
  TextEditingController descriptionController = TextEditingController();
  Uint8List? pickedImage;
  bool isLoading = false;
  @override
  void initState() {
    descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
  }

  void postImage(String uid, String username, String profileUrl, String address,
      String name) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FireStorePostMethods().uploadPost(
          descriptionController.text,
          pickedImage!,
          uid,
          username,
          address,
          profileUrl,
          name);
      setState(() {
        isLoading = false;
      });
      if (res == "success") {
        showSnackBar(context, "Posted");
      } else {
        showSnackBar(context, "error in uploading");
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    clearPickedImage();
  }

  void clearPickedImage() {
    setState(() {
      pickedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, value, _) {
      UserData userData = value.getUser;
      return Scaffold(
        body: Column(
          children: <Widget>[
            isLoading
                ? const LinearProgressIndicator()
                : const Padding(padding: EdgeInsets.only(top: 0)),
            const SizedBox(
              height: 32,
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: 350,
                      height: 250,
                      color: Colors.grey[300],
                      child: pickedImage != null
                          ? Image.memory(
                              pickedImage!,
                              fit: BoxFit.cover,
                            )
                          : GestureDetector(
                              onTap: () {
                                _selectImage(context);
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            )),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  contentPadding: EdgeInsets.only(left: 5),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  if (pickedImage != null) {
                    postImage(userData.uid, userData.username,
                        userData.profileUrl, userData.address, userData.name);
                  }
                },
                child: const Text('Upload'))
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () async {
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  pickedImage = file;
                });
              },
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo_library),
            ),
            const SizedBox(
              height: 16,
            ),
            FloatingActionButton(
              onPressed: () async {
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  pickedImage = file;
                });
              },
              tooltip: 'Take a photo',
              child: const Icon(Icons.photo_camera),
            ),
          ],
        ),
      );
    });
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
                child: const Text('cancle'),
              )
            ],
          );
        });
  }
}
