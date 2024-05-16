import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplink/Providers/user_provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(
      {super.key,
      required this.webScreenLayout,
      required this.mobileScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    userData();
  }

  userData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUserData();
    print(3);
    print("responsive screen ${userProvider.getUser.name}");
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // display web screen layout
          return widget.webScreenLayout;
        } else {
          // display  mobile screen layout
          return widget.mobileScreenLayout;
        }
      },
    );
  }
}
