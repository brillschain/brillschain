// import 'dart:js';

// import 'package:supplink/AppIntro/welcome.dart';
import 'package:supplink/Authentication/Logins/loginview.dart';
// import 'package:supplink/Authentication/Logins/phoneLoginView.dart';
import 'package:supplink/Authentication/signup.dart';
import 'package:supplink/Home/desktop_Body.dart';
// import 'package:supplink/Home/drawer_pages/LanePages/laneview.dart';
// import 'package:supplink/Home/drawer_pages/dashBoard.dart';
import 'package:supplink/Trails/comments.dart';
// import 'package:supplink/Trails/fakes/homepag.dart';

class AppRoutes {
  static const String LoginRoute = '/login';
  static const String SignUpRoute = '/signup';
  static const String Myhomepage = '/homepage';
  static const String PhonePageRoute = '/phoneverify';
  static const String LaneViewRoute = '/laneview';
  static const String CommentsRoute = '/comments';
  // static const String WelcomeRoute = 'welcome';

  static final Routes = {
    LoginRoute: (context) => const LoginView(),
    SignUpRoute: (context) => const SignUp(),
    Myhomepage: (context) => DesktopBody(),
    // PhonePageRoute: (context) => PhoneNumberAuthView(),
    // LaneViewRoute: (context) => LaneView(),
    CommentsRoute: (context) => CommentPage(),
    // WelcomeRoute: (context) => WelcomePage(),
  };
}
