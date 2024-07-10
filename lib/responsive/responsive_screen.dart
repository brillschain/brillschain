import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplink/Home/home_page/desktop_Body.dart';
import 'package:supplink/Providers/user_provider.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:supplink/responsive/mobile_screen.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({
    super.key,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  final User user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    userData();
  }

  userData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUserData();
    userProvider.getPosts();
    userProvider.refreshAllUserData();
    updatestatus(userProvider);
  }

  void updatestatus(UserProvider provider) {
    html.document.onVisibilityChange.listen((event) async {
      if (html.document.hidden!) {
        // Page is hidden
        await provider.updateUserStatus({'isonline': false});
      } else {
        // print('status');
        // Page is visible
        await provider.updateUserStatus({
          'lastseen': DateTime.now(),
          'isonline': true,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, data, _) {
      return data.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  // display web screen layout
                  return const DesktopBody();
                } else {
                  // display  mobile screen layout
                  return const MobileScreen();
                }
              },
            );
    });
  }
}
