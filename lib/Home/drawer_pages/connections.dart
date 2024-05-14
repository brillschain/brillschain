import 'package:flutter/material.dart';
import 'package:supplink/Home/drawer_pages/connectionsFolder/homeConnections.dart';
import 'package:supplink/Home/drawer_pages/connectionsFolder/homeConnectionsClasses/messages/messagesConnections.dart';
// import 'package:supplink/Home/drawer_pages/connectionsFolder/messages/messagesConnections.dart';
import 'package:supplink/Home/drawer_pages/connectionsFolder/myPostsConnections.dart';
import 'package:supplink/Home/drawer_pages/connectionsFolder/my_connections.dart';
// import 'package:supplink/Home/drawer_pages/connectionsFolder/newPostsConnections.dart';
import 'package:supplink/Home/drawer_pages/connectionsFolder/settingsConnections.dart';
import 'package:supplink/Home/posts/picupload.dart';

class Connections extends StatefulWidget {
  const Connections({super.key});

  @override
  State<Connections> createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  int _selectedbottonNaviButton = 0;

  void changeSelectBottomNavi(int index) {
    setState(() {
      _selectedbottonNaviButton = index;
    });
  }

  List _connectionPages = [
    HomeConnections(),
    // MyPostsConnections(),
    MyPosts(),
    // NewPostsConnections(),
    ImageUploads(),
    MessagesConnections(),
    SettingsConnections(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: 1,

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                tooltip: String.fromEnvironment('Home'),
                backgroundColor: Color.fromARGB(255, 236, 234, 234)),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize_outlined),
              label: 'My posts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_upload_rounded),
              label: 'New Posts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_rounded),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedbottonNaviButton,
          // fixedColor: const Color.fromARGB(255, 204, 202, 202),
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.amber[800],
          onTap: changeSelectBottomNavi,
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => My_connections())));
                    },
                    child: Text(
                      'Connects',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'New Connects',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ],
            )
          ],
        ),
        //  drawer: navigationDrawer(),
        body: _connectionPages[_selectedbottonNaviButton]);
  }
}
