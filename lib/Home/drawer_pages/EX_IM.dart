import 'package:flutter/material.dart';
// import 'package:supplink/Home/constants.dart';

class EX_IM extends StatelessWidget {
  static const String routeName = '/EX_IM';

  const EX_IM({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        //  appBar: myAppBar,
        //  drawer: navigationDrawer(),
        body: Center(child: Text("This is EX_IM page")));
  }
}

class EX_IM_navigation_drawer extends StatelessWidget {
  const EX_IM_navigation_drawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer();
  }
}
