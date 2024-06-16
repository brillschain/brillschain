import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:supplink/Adapots_dummy/theme/app_theme.dart';
import 'package:supplink/AppIntro/welcome.dart';
import 'package:supplink/Home/desktop_Body.dart';
import 'package:supplink/Providers/authAppProvider.dart';
import 'package:supplink/Routes/Routes.dart';
// import 'package:supplink/Providers/firebase/firebase_providers.dart';
// import 'package:supplink/Trails/comments.dart';
import 'package:supplink/firebase_options.dart';
import 'package:supplink/responsive/mobile_screen.dart';
import 'package:supplink/responsive/responsive_screen.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "BrillsChain",
        routes: AppRoutes.routes,

        // home: ProfilePageTest(),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                    webScreenLayout: DesktopBody(),
                    mobileScreenLayout: MobileScreen());
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("error will loading the data"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                      // color: primaryColor,
                      ),
                );
              }

              return const WelcomePage();
            }),
      ),
    );
  }
}
