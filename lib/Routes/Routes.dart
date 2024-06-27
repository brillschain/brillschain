import 'package:supplink/Authentication/Logins/loginview.dart';
import 'package:supplink/Authentication/signup.dart';
import 'package:supplink/responsive/responsive_screen.dart';

class AppRoutes {
  static const String loginRoute = '/login';
  static const String signUpRoute = '/signup';
  static const String myhomepage = '/homepage';
  static const String phonePageRoute = '/phoneverify';
  static const String laneViewRoute = '/laneview';
  static const String commentsRoute = '/comments';
  // static const String WelcomeRoute = 'welcome';

  static final routes = {
    loginRoute: (context) => const LoginView(),
    signUpRoute: (context) => const SignUp(),
    myhomepage: (context) => const ResponsiveLayout(),
    // PhonePageRoute: (context) => PhoneNumberAuthView(),
    // LaneViewRoute: (context) => LaneView(),

    // WelcomeRoute: (context) => WelcomePage(),
  };
}
