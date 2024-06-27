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
    return Container(
      child: Row(
        children: [
          Card(
            elevation: 3,
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              height: double.infinity,
              width: 550,
              child: const PostScreen(),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      child: const MapView(),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
