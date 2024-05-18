// import 'dart:collection';
// import 'dart:convert';
// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_marker_popup/extension_api.dart';
// import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseCredentials/.dart';
import 'package:supplink/Backend/firebase/allUserDetails.dart';
import 'package:supplink/Providers/user_provider.dart';
import 'package:supplink/models/user_model.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:async/async.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  bool infoWindowVisible = false;
  UserData? selectedUser;
  List<UserData> fetchedUsers = [];

  @override
  void initState() {
    super.initState();
    // fetchUserDetails();
  }

  // Future<void> fetchUserDetails() async {
  //   AllUserDetailsExtract allUserDetailsExtract = AllUserDetailsExtract();
  //   List<UserDetails> fetchedusersdetails =
  //       await allUserDetailsExtract.fetchAllUserDetails();
  //   setState(() {
  //     fetchedUsers = fetchedusersdetails;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    List<UserData> fetchedUsers =
        Provider.of<UserProvider>(context).getAllUserData;
    // print('build widget');
    if (fetchedUsers.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              // ignore: deprecated_member_use
              center: LatLng(15.9129, 79.7400),
              // ignore: deprecated_member_use
              zoom: 6,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                // urlTemplate:
                //     'https://stamen-tiles.a.ssl.fastly.net/toner-background/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: fetchedUsers
                    .map((userInfo) => buildMarker(userInfo))
                    .toList(),
              )
            ],
          ),
          if (infoWindowVisible == true) popupView(),
        ],
      ),
    );
  }

  // Marker buildMarker(LatLng coordinates, String word) {
  Marker buildMarker(UserData userInfo) {
    // print('build marker');
    final user = FirebaseAuth.instance.currentUser;
    double lat = userInfo.coordinates.latitude;
    double lng = userInfo.coordinates.longitude;
    LatLng latLng = LatLng(lat, lng);
    return Marker(
      point: latLng,
      width: 100,
      height: 100,
      child: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              height: 80,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    infoWindowVisible = !infoWindowVisible;
                    selectedUser = userInfo;
                  });
                  // print("on tapped");
                  // popupView(word);
                },
                child: Column(
                  children: [
                    user?.uid == userInfo.uid
                        ? const Icon(
                            Icons.location_pin,
                            color: Colors.blue,
                            size: 30,
                          )
                        : const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 30,
                          ),
                    buildTextWidget(userInfo.domain),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  TextStyle getDefaultTextStyle() {
    return const TextStyle(
      fontSize: 12,
      backgroundColor: Colors.black,
      color: Colors.white,
    );
  }

  Widget buildTextWidget(String word) {
    return Container(
      alignment: Alignment.center,
      child:
          Text(word, textAlign: TextAlign.center, style: getDefaultTextStyle()),
    );
  }

  Widget popupView() {
    // print("in the widget");
    return Positioned(
        top: 150, // Adjust the top position as needed
        left: 200,
        right: 1,
        bottom: 10,
        child: Container(
          height: 320,
          width: 200,
          child: AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    selectedUser!.profileUrl.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage:
                                NetworkImage(selectedUser!.profileUrl),
                            radius: 25,
                          )
                        : const Icon(
                            Icons.account_circle_sharp,
                            size: 50,
                          ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                // Text('Hello!'),
                Text("Name: ${selectedUser!.name}"),
                Text("Domain: ${selectedUser!.domain}"),
                Text("Phone:${selectedUser!.phoneno}"),
                Text("Address:${selectedUser!.address}")
                // Replace this with your custom pop-up content
                // Add any other widgets you want in the pop-up
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    infoWindowVisible = false;
                  });
                },
                child: Text('Close'),
              ),
            ],
          ),
        ));
  }
}
