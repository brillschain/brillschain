import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplink/Home/desktop_Body.dart';
import 'package:supplink/Providers/user_provider.dart';
import 'package:supplink/models/user_model.dart';

class WebScreen extends StatelessWidget {
  const WebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserProvider>(context).getUser;
    return Center(
      child: Text(userData.name),
    );
  }
}
