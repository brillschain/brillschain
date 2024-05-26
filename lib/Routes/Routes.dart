import 'package:supplink/Authentication/Logins/loginview.dart';
import 'package:supplink/Authentication/signup.dart';
import 'package:supplink/Home/desktop_Body.dart';

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
    Myhomepage: (context) => const DesktopBody(),
    // PhonePageRoute: (context) => PhoneNumberAuthView(),
    // LaneViewRoute: (context) => LaneView(),

    // WelcomeRoute: (context) => WelcomePage(),
  };
}
