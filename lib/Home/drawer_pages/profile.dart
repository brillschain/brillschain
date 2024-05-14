import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:supabase/supabase.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseCredentials.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseServices/Strorages/connectionsUrlManager.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseServices/Strorages/constants.dart';
// import 'package:supplink/Backend/firebase/userDeatilsmaintain.dart';
// import 'dart:math';
// import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:supplink/Backend/firebase/userDetailsmaintain.dart';
// import 'package:supplink/Home/desktop_Body.dart';
// import 'package:supplink/Home/drawer_pages/connectionsFolder/homeConnectionsClasses/userLocation.dart';

class Profile extends StatefulWidget {
  static const String routeName = '/Profile';
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Map<String, dynamic>? user_details = {};
  late String profilePublic_Url = '';
  late UserProfileHandler userProfileHandler;
  bool isEditing = false;
  late TextEditingController nameController;
  late TextEditingController domainController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController emailController;
  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    userProfileHandler = UserProfileHandler();
  }

  Future<void> fetchUserDetails() async {
    UserDetailsTable userDetailsTable = UserDetailsTable();
    Map<String, dynamic>? current_user =
        await userDetailsTable.fetchCurrentUserDetails();
    Map<String, dynamic>? profile = await userDetailsTable.fetchprofileurl();

    String url = profile == null ? '' : profile['Profileurl'];
    Map<String, dynamic> details = current_user ?? {};
    // print(details);
    setState(() {
      user_details = details;
      profilePublic_Url = url;
      nameController = TextEditingController(text: user_details!['Name']);
      domainController = TextEditingController(text: user_details!['Domain']);
      phoneController =
          TextEditingController(text: user_details!['Phone'].toString());
      locationController =
          TextEditingController(text: user_details!['Village']);
      emailController = TextEditingController(text: user_details!['Email']);
    });
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Uint8List? imageBytes;
  var uploadedPhotoUrl = '';
  final ImagePicker _picker = ImagePicker();
  var profileurl = '';

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        imageBytes = bytes;
        uploadFile();
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
        uploadFile();
      });
    } else {
      print('No image selected.');
    }
  }

  Future uploadFile() async {
    UserDetailsTable userDetailsTable = UserDetailsTable();
    // DesktopBodyState desktopBody = DesktopBodyState();

    Map<String, dynamic>? current_user =
        await userDetailsTable.fetchCurrentUserDetails();
    if (imageBytes == null) return;
    final uid = current_user!['Auth_id'];
    final destination = 'Posts/$uid';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('Profile/');
      await ref
          .putData(imageBytes!, SettableMetadata(contentType: 'image/png'))
          .whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          setState(() {
            uploadedPhotoUrl = value;
            userDetailsTable.addprofile(uid, uploadedPhotoUrl);
            profilePublic_Url = uploadedPhotoUrl;
          });
          // updateProfile(uploadedPhotoUrl);
          // desktopBody.updateProfilePicture(profilePublic_Url);
        });
      });
      // print(uploadedPhotoUrl);
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('profile'),
          centerTitle: true,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 30),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.settings,
                  ),
                )),
          ],
        ),
        body: user_details!.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: 500,
                    decoration: BoxDecoration(
                        // border: Border.all(width: 2),
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: ListView(
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                profilePublic_Url == ''
                                    ? Container(
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 4, color: Colors.white),
                                          boxShadow: [
                                            BoxShadow(
                                                spreadRadius: 2,
                                                blurRadius: 10,
                                                color: Colors.black
                                                    .withOpacity(0.1))
                                          ],
                                          shape: BoxShape.circle,
                                        ))
                                    : Container(
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 4, color: Colors.white),
                                            boxShadow: [
                                              BoxShadow(
                                                  spreadRadius: 2,
                                                  blurRadius: 10,
                                                  color: Colors.black
                                                      .withOpacity(0.1))
                                            ],
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center,
                                                image: NetworkImage(
                                                    profilePublic_Url)))),
                                Positioned(
                                    // top: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await imgFromGallery();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 4, color: Colors.white),
                                            color: Colors.blue[200]),
                                        child: Icon(Icons.edit),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          // buildTextField('Name', user_details!['Name'], false),
                          // buildTextField(
                          //     'Domain', user_details!['Domain'], false),
                          // buildTextField('Phone',
                          //     user_details!['Phone'].toString(), false),
                          // buildTextField('Location',
                          //     user_details!['Location'].toString(), false),
                          // buildTextField(
                          //     'Email', user_details!['Email'], false),
                          buildTextField('Name', nameController, false),
                          buildTextField('Domain', domainController, false),
                          buildTextField('Phone', phoneController, false),
                          buildTextField('Location', locationController, false),
                          buildTextField('Email', emailController, false),

                          //TODO step verification
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      fixedSize: const MaterialStatePropertyAll(
                                          Size.fromWidth(150)),
                                      padding: MaterialStatePropertyAll(
                                        EdgeInsets.symmetric(vertical: 15),
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      isEditing = true;
                                    });
                                  },
                                  child: Text(
                                    'edit',
                                    style: TextStyle(fontSize: 18),
                                  )),
                              SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      fixedSize: const MaterialStatePropertyAll(
                                          Size.fromWidth(150)),
                                      padding: MaterialStatePropertyAll(
                                        EdgeInsets.symmetric(vertical: 15),
                                      )),
                                  onPressed: isEditing
                                      ? () {
                                          userProfileHandler
                                              .updateProfileDetails(
                                                  nameController,
                                                  domainController,
                                                  phoneController,
                                                  locationController,
                                                  emailController,
                                                  context);
                                          setState(() {
                                            isEditing = false;
                                          });
                                        }
                                      : null,
                                  child: Text(
                                    'save',
                                    style: TextStyle(fontSize: 18),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
        // : Center(child: CircularProgressIndicator()),
        );
  }

  Widget buildTextField(
      String labeltext, TextEditingController controller, bool isPassword) {
    // TextEditingController textEditingController = TextEditingController();
    // String userDetails = details;
    // textEditingController.text = userDetails;
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextField(
        obscureText: isPassword,
        enabled: isEditing,
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? IconButton(onPressed: () {}, icon: Icon(Icons.remove_red_eye))
              : null,
          contentPadding: EdgeInsets.only(bottom: 5, left: 5),
          labelText: labeltext,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class UserProfileHandler {
  Future<void> updateProfileDetails(
      TextEditingController nameController,
      TextEditingController domainController,
      TextEditingController phoneController,
      TextEditingController locationController,
      TextEditingController emailController,
      BuildContext context) async {
    // print('profile details update function');
    final user = FirebaseAuth.instance.currentUser;
    final collectionRef = FirebaseFirestore.instance.collection('AllUsers');

    try {
      await collectionRef.doc(user?.uid).update({
        'Name': nameController.text,
        'Domain': domainController.text,
        'Phone': int.parse(phoneController.text),
        'Village': locationController.text,
        'Email': emailController.text,
      }).then((_) {
        // print("ProfileDetails updated successfully!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    } catch (error) {
      print("Failed to update the ProfileDetails: $error");
    }
  }
}
