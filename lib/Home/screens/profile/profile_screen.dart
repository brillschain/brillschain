// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:supplink/Providers/profile_provider.dart';
import 'package:supplink/Providers/user_provider.dart';
import 'package:supplink/models/user_model.dart';
import '../../../utils/image_picker.dart';
import '../../../utils/toaster.dart';
import '../posts/widgets/post_body.dart';
import '../user_contracts_stasts/contract_stats.dart';
import 'widget/custom_button.dart';
import 'widget/data_column.dart';
import 'widget/details_row.dart';
import 'widget/edit_text_field.dart';

class ProfilePageview extends StatefulWidget {
  final String uid;
  const ProfilePageview({super.key, required this.uid});

  @override
  State<ProfilePageview> createState() => _ProfilePageviewState();
}

class _ProfilePageviewState extends State<ProfilePageview> {
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.init(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Padding(
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
          child: AppBar(
            title: const Text('Profile'),
            centerTitle: false,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(width: 10),
            const Column(
              children: [
                ProfileCard(),
                SizedBox(
                  height: 16,
                ),
                StatisticsSection(),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              // flex: 1,
              child: widget.uid != user.uid
                  ? UserPosts(uid: widget.uid)
                  : const ContractList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  // final UserData userData;
  const ProfileCard({
    super.key,
    // required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, data, _) {
      return data.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Card(
              elevation: 0,
              child: Container(
                width: 420,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          // flex: 1,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(data.userData.profileUrl),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(data.userData.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              const Text(
                                'username',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          width: 220,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DetailsRow(
                                  icon: Icons.domain,
                                  data: data.userData.domain),
                              DetailsRow(
                                  icon: Icons.location_on_rounded,
                                  data: data.userData.address),
                              DetailsRow(
                                  icon: Icons.phone,
                                  data: data.userData.phoneno.toString()),
                              DetailsRow(
                                icon: Icons.email,
                                data: data.userData.email,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        UserDataColumn(
                          name: 'posts',
                          value: data.noOfPosts.toString(),
                        ),
                        UserDataColumn(
                          name: 'Connections',
                          value: data.userData.connections.length.toString(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        data.isCurrentUser
                            ? CustomProfileButton(
                                const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                onTap: () {
                                  showEditProfileDialog(context, data);
                                },
                                text: 'Edit Profile',
                                backgroundcolor: Colors.blue,
                                textColor: Colors.white,
                                width: MediaQuery.of(context).size.width > 600
                                    ? 150
                                    : 120,
                              )
                            : CustomProfileButton(
                                Icon(
                                  data.isConnection
                                      ? Icons.person_remove
                                      : Icons.person_add,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                onTap: () async {
                                  await data
                                      .manageConnection(data.userData.uid);

                                  toastMessage(
                                    context: context,
                                    message:
                                        "${data.userData.name} is ${data.res}",
                                    position: DelightSnackbarPosition.bottom,
                                  );
                                  // Navigator.of(context).pop();
                                },
                                text: data.isConnection
                                    ? 'Disconnect'
                                    : 'Connect',
                                backgroundcolor: Colors.blue,
                                textColor: Colors.white,
                                width: MediaQuery.of(context).size.width > 600
                                    ? 150
                                    : 120,
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomProfileButton(
                          const Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 24,
                          ),
                          onTap: () {},
                          text: 'share',
                          backgroundcolor: Colors.black,
                          textColor: Colors.white,
                          width: MediaQuery.of(context).size.width > 600
                              ? 150
                              : 120,
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
    });
  }
}

void showEditProfileDialog(
    BuildContext context, ProfileProvider profileProvider) {
  UserData userData = profileProvider.userData;
  final nameController = TextEditingController(text: userData.name);
  final emailController = TextEditingController(text: userData.email);
  final addressController = TextEditingController(text: userData.address);
  final pincodeController =
      TextEditingController(text: userData.pincode.toString());
  final phoneNoController =
      TextEditingController(text: userData.phoneno.toString());
  String profileUrl = userData.profileUrl;
  // Add more controllers as needed
  updateMessage(String res) {
    toastMessage(
        context: context,
        message: res == 'updated'
            ? "Profile Updated Successfully"
            : "Failed to update $res",
        position: DelightSnackbarPosition.bottom);
    Navigator.of(context).pop();
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer<UserProvider>(builder: (context, data, _) {
        // print(data.profileImage);
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  children: [
                    data.profileImage != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(data.profileImage!),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(profileUrl),
                          ),
                    Positioned(
                        bottom: -1,
                        right: -10,
                        child: IconButton(
                          onPressed: () {
                            data.selectImage();
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            size: 26,
                          ),
                        ))
                  ],
                ),
                EditTextField(label: 'Name', controller: nameController),
                EditTextField(label: 'Phone No', controller: phoneNoController),
                EditTextField(label: 'Email', controller: emailController),
                EditTextField(label: 'Address', controller: addressController),
                EditTextField(label: 'Pin Code', controller: pincodeController),

                // Add more fields as needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                if (data.profileImage != null) {
                  await data.generateProfileUrl();
                  profileUrl = data.profileUrl ?? profileUrl;
                }

                UserData user = UserData(
                    uid: userData.uid,
                    name: nameController.text,
                    email: emailController.text,
                    coordinates: userData.coordinates,
                    profileUrl: profileUrl,
                    domain: userData.domain,
                    address: addressController.text,
                    phoneno: int.parse(phoneNoController.text),
                    username: userData.username,
                    connections: userData.connections,
                    lastseen: userData.lastseen,
                    pincode: int.parse(pincodeController.text));

                String res = await data.updateUserData(user);

                updateMessage(res);
                profileProvider.refreshUserData(userData.uid);
              },
            ),
          ],
        );
      });
    },
  );
}

class StatisticsSection extends StatefulWidget {
  const StatisticsSection({super.key});

  @override
  State<StatisticsSection> createState() => _StatisticsSectionState();
}

class _StatisticsSectionState extends State<StatisticsSection> {
  Map<String, double> dataMap = {
    "ongoing": 5,
    "completed": 10,
    "Scheduled": 6,
    "cancelled": 1,
  };
  List<Color> colorList = [
    const Color(0xff3398F6),
    const Color(0xff3EE094),
    const Color(0xffD95AF3),
    const Color(0xffFA4A42),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(16).copyWith(bottom: 8),
        width: 420,
        child: Column(
          children: [
            const Text(
              'Contract History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                dataMap: dataMap,
                animationDuration: const Duration(milliseconds: 1000),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 6.5,
                colorList: colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
                centerText: "contracts",
                legendOptions: const LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.right,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserPosts extends StatelessWidget {
  final String uid;
  const UserPosts({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0).copyWith(top: 8),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .where('uid', isEqualTo: uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No posts available"),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return PostCard(snapshot: snapshot.data!.docs[index].data());
                },
              );
            }),
      ),
    );
  }
}
