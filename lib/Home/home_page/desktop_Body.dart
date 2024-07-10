import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:supplink/Home/drawer_pages/EX_IM.dart';
import 'package:supplink/Home/drawer_pages/connections.dart';
import 'package:supplink/Home/drawer_pages/dashBoard.dart';
import 'package:supplink/Home/drawer_pages/check_updates.dart';
import 'package:supplink/Home/drawer_pages/laneWorks.dart';
import 'package:supplink/Home/screens/profile/profile_screen.dart';
import 'package:supplink/Providers/user_provider.dart';
import 'package:supplink/models/user_model.dart';

import 'widgets/messages.dart';

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
    super.initState();
  }

  void init() {
    selectedIndex = widget.index ?? 0;
    uid = widget.uid ?? FirebaseAuth.instance.currentUser!.uid;
    pages_ = [
      const DashBoard(),
      const EX_IM(),
      const Check_Updates(),
      ProfilePageview(
        uid: selectedIndex != 3 ? uid! : FirebaseAuth.instance.currentUser!.uid,
      ),
      const Connections(),
      const LaneWorks(),
    ];
  }

  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);

  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       // print('app life cycle');
  //       UserProvider().updateUserStatus({
  //         'lastseen': DateTime.now(),
  //         'isonline': true,
  //       });
  //       break;

  //     case AppLifecycleState.inactive:
  //     case AppLifecycleState.paused:
  //     case AppLifecycleState.detached:
  //       FirebaseFirestoreServiceMessages.updateUserData({'isonline': false});
  //       break;
  //     case AppLifecycleState.hidden:
  //   }
  // }

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
      floatingActionButton: selectedIndex != 4
          ? const MessagesFloatingAction()
          : const SizedBox(),
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
