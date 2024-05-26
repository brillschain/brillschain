// import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supplink/Providers/firebase/firebase_providers.dart';
import 'package:supplink/Providers/user_provider.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    // ChangeNotifierProvider(create: (_) => Authenticationotifier()),
    ChangeNotifierProvider(create: (_) => FirebaseProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider())
  ];
}
