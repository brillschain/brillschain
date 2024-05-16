import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseServices/Strorages/constants.dart';
import 'package:supplink/Backend/firebase/userDetailsmaintain.dart';
import 'package:supplink/Home/drawer_pages/EX_IM.dart';
// import 'package:supplink/Home/drawer_pages/LanePages/contractViews.dart';
import 'package:supplink/Home/drawer_pages/connections.dart';
import 'package:supplink/Home/drawer_pages/dashBoard.dart';
import 'package:supplink/Home/drawer_pages/check_updates.dart';
// import 'package:supplink/Home/constants.dart';
import 'package:supplink/Home/drawer_pages/laneWorks.dart';
import 'package:supplink/Home/drawer_pages/profile.dart';
import 'package:supplink/Providers/user_provider.dart';
import 'package:supplink/models/user_model.dart';
// import 'package:supplink/Home/drawer_pages/connectionsFolder/my_connections.dart';
// import 'package:provider/provider.dart';

class DesktopBody extends StatefulWidget {
  const DesktopBody({super.key});
  @override
  State<DesktopBody> createState() => DesktopBodyState();
}

class DesktopBodyState extends State<DesktopBody> {
  int selectedIndex = 0;
  String profilepic = '';
  Map<String, dynamic>? curUserdetails = {};

  @override
  void initState() {
    super.initState();
    // FetchCurrentUserDetails();
    // currentUserDetails();
  }

  // currentUserDetails() async {
  //   UserProvider userProvider = Provider.of(context, listen: false);
  //   await userProvider.refreshUserData();
  // }

  // void FetchCurrentUserDetails() async {
  //   UserDetailsTable userDetailsTable = UserDetailsTable();
  //   Map<String, dynamic>? currentUser =
  //       await userDetailsTable.fetchCurrentUserDetails();
  //   print('current user: ${currentUser}');
  //   Map<String, dynamic>? profile = await userDetailsTable.fetchprofileurl();
  //   // print(profile);
  //   String url = profile == null ? '' : profile['Profileurl'];
  //   Map<String, dynamic> details = currentUser ?? {};
  //   // print(url);
  //   // print('desktop body');
  //   setState(() {
  //     curUserdetails = details;
  //     profilepic = url;
  //   });
  // }

  // void updateProfilePicture(String newUrl) {
  //   print('profile pic updated in desktop');
  //   setState(() {
  //     profilepic = newUrl;
  //   });
  // }

  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List pages_ = [
    const DashBoard(),
    const EX_IM(),
    const Check_Updates(),
    const Profile(),
    const Connections(),
    const LaneWorks(),
    // const ContractView()

    // My_connections(),
  ];

  @override
  Widget build(BuildContext context) {
    // final SelectedIndexProvider selectedIndexProvider = Provider.of<SelectedIndexProvider>(context);
    UserData userData = Provider.of<UserProvider>(context).getUser;

    return Row(
      children: [
        navi(userData),
        // myDrawer,
        Expanded(child: pages_[selectedIndex]),
      ],
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
              style: TextStyle(color: Colors.black),
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
