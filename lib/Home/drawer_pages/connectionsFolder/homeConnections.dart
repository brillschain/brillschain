// import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:supplink/Home/screens/userLocation.dart';
import 'package:supplink/Home/screens/posts/posts_screen.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:supplink/Home/drawer_pages/connectionsFolder/homeConnectionsClasses/Comments.dart';
// import 'package:shimmer/shimmer.dart'; // import shimmer package

class HomeConnections extends StatefulWidget {
  const HomeConnections({super.key});

  @override
  State<HomeConnections> createState() => _HomeConnectionsState();
}

class _HomeConnectionsState extends State<HomeConnections> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: 2)
                ]),
            height: double.infinity,
            width: 550,
            child: const PostScreen(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        spreadRadius: 2)
                  ]),
              // width: double.infinity,
              child: const MapView(),
            ),
          ),
        )
      ],
    );
  }
}
