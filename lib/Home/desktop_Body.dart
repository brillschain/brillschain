import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:supplink/Backend/firebase/firebase_firestore_services_msg.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseServices/Strorages/constants.dart';
import 'package:supplink/Home/drawer_pages/EX_IM.dart';
// import 'package:supplink/Home/drawer_pages/LanePages/contractViews.dart';
import 'package:supplink/Home/drawer_pages/connections.dart';
import 'package:supplink/Home/drawer_pages/dashBoard.dart';
import 'package:supplink/Home/drawer_pages/check_updates.dart';
// import 'package:supplink/Home/constants.dart';
import 'package:supplink/Home/drawer_pages/laneWorks.dart';
import 'package:supplink/Home/screens/profile/profile_screen.dart';
import 'package:supplink/Providers/user_provider.dart';
import 'package:supplink/models/user_model.dart';
// import 'package:supplink/Home/drawer_pages/connectionsFolder/my_connections.dart';
// import 'package:provider/provider.dart';

class DesktopBody extends StatefulWidget {
  final int? index;
  final String? uid;
  const DesktopBody({
    super.key,
    this.index,
    this.uid,
  });
  @override
  State<DesktopBody> createState() => DesktopBodyState();
}

class DesktopBodyState extends State<DesktopBody> with WidgetsBindingObserver {
  int selectedIndex = 0;
  String? uid;
  List pages_ = [];
  @override
  void initState() {
    init();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void init() {
    selectedIndex = widget.index ?? 0;
    uid = widget.uid ?? FirebaseAuth.instance.currentUser!.uid;
    pages_ = [
      const DashBoard(),
      const EX_IM(),
      const Check_Updates(),
      // const Profile(),
      // ProfileScreen(
      //   uid: FirebaseAuth.instance.currentUser!.uid,
      // ),
      ProfilePageview(
        uid: uid!,
      ),
      const Connections(),
      const LaneWorks(),
      // const ContractView()

      // My_connections(),
    ];
  }

  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        FirebaseFirestoreServiceMessages.updateUserData({
          'lastseen': DateTime.now(),
          'isonline': true,
        });
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        FirebaseFirestoreServiceMessages.updateUserData({'isonline': false});
        break;
      case AppLifecycleState.hidden:
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    // final SelectedIndexProvider selectedIndexProvider = Provider.of<SelectedIndexProvider>(context);
    UserData userData =
        Provider.of<UserProvider>(context, listen: true).getUser;
    return Scaffold(
      body: Row(
        children: [
          navi(userData),
          // myDrawer,
          Expanded(child: pages_[selectedIndex]),
        ],
      ),
      floatingActionButton: const MessagesFloatingAction(),
    );
  }

  Widget navi(UserData userData) {
    // final SelectedIndexProvider selectedIndexProvider = Provider.of<SelectedIndexProvider>(context);

    return Drawer(
      width: 220,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(userData),
          createDrawerBodyItem(
              icon: Icons.dashboard,
              text: 'DashBoard',
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(builder: ((context) => DashBoard())));
                setSelectedIndex(0);
                // selectedIndexProvider.setSelectedIndex(0);
              }),
          createDrawerBodyItem(
              icon: Icons.add_circle_outline,
              text: 'EX_IM',
              onTap: () {
                //  Navigator.pushReplacementNamed(context, pageRoutes.eX_IM),
                // Navigator.of(context).push(MaterialPageRoute(builder: ((context) => EX_IM())));
                setSelectedIndex(1);
                // selectedIndexProvider.setSelectedIndex(1);
              }),
          createDrawerBodyItem(
              icon: Icons.currency_bitcoin,
              text: 'Lane works',
              onTap: () {
                setSelectedIndex(5);
                // selectedIndexProvider.setSelectedIndex(4);
              }),
          createDrawerBodyItem(
              icon: Icons.notifications_active_outlined,
              text: 'Check_Updates',
              onTap: () {
                setSelectedIndex(2);
                // selectedIndexProvider.setSelectedIndex(2);
              }),
          createDrawerBodyItem(
              icon: Icons.perm_device_information_outlined,
              text: 'Profile',
              onTap: () {
                setSelectedIndex(3);
                // selectedIndexProvider.setSelectedIndex(3);
              }),
          createDrawerBodyItem(
              icon: Icons.connect_without_contact_outlined,
              text: 'Connections',
              onTap: () {
                setSelectedIndex(4);
                // selectedIndexProvider.setSelectedIndex(4);
              }),
          ListTile(
            title: const Text('App version 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget createDrawerHeader(UserData userData) {
    return userData.profileUrl == ''
        ? UserAccountsDrawerHeader(
            accountName: Text(
              userData.name.isEmpty ? '' : userData.name,
              style: const TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              userData.email.isEmpty ? '' : userData.email,
              style: const TextStyle(color: Colors.white),
            ),
          )
        : UserAccountsDrawerHeader(
            accountName: Text(
              userData.name.isEmpty ? '' : userData.name,
              style: const TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              userData.email.isEmpty ? '' : userData.email,
              style: const TextStyle(color: Colors.black),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(userData.profileUrl
                    // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGHBxyJ__hFyYKK3b5st1p1YRKWGSYZngEAw&usqp=CAU",
                    ),
                fit: BoxFit.fill,
              ),
            ),
          );
  }

  Widget createDrawerBodyItem(
      {IconData? icon, String? text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text!),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}

class MessagesFloatingAction extends StatelessWidget {
  const MessagesFloatingAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        width: 370,
        padding: const EdgeInsets.symmetric(vertical: 8),
        // height: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                print('ontap');
              },
              hoverColor: Colors.blue[200],
              splashColor: Colors.blue[300],
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                  radius: 24,
                                  // foregroundImage: widget.user.profileUrl != ''
                                  //     ? NetworkImage(widget.user.profileUrl)
                                  //     : null,
                                  child: Text('N')),
                              Padding(
                                padding: EdgeInsets.only(bottom: 6, right: 1),
                                child: CircleAvatar(
                                    radius: 5, backgroundColor: Colors.red),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Messaging',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_up,
                      size: 32,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: TextFormField(
                // onChanged: widget.onSearch,
                // controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 26,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(117, 192, 223, 251),
                  contentPadding: const EdgeInsets.all(0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
