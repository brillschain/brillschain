import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:supplink/Backend/auth/user_auth.dart';
import 'package:supplink/Home/widgets/auth_button.dart';
import 'package:supplink/Home/widgets/auth_layout.dart';
import 'package:supplink/Home/widgets/auth_text_field.dart';
import 'package:supplink/Home/widgets/main_app_bar.dart';
// import 'package:supplink/Backend/firebase/userDeatilsmaintain.dart';
import 'package:supplink/Providers/core/notifiers/authenticationnotifier.dart';
import 'package:supplink/Providers/user_provider.dart';
import 'package:supplink/Routes/Routes.dart';
import 'package:supplink/responsive/mobile_screen.dart';
import 'package:supplink/responsive/responsive_screen.dart';
import 'package:supplink/responsive/web_screen.dart';
import 'package:supplink/utils/snackbars.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isloading = false;
  late AnimationController _animationController;
  // ignore: unused_field
  late Animation<double> _animation;
  late AnimationController _titleAnimationController;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();

    _titleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    );

    _titleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _titleAnimationController,
        curve: Curves.easeOutSine,
      ),
    );

    _titleAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _titleAnimationController.stop();
      }
    });

    _titleAnimationController.forward();
  }

  currentUserDetails() async {
    try {
      UserProvider userProvider = Provider.of(context, listen: false);
      await userProvider.refreshUserData();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // final Authenticationotifier authenticationotifier =
    //     Provider.of<Authenticationotifier>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const MainAppBar(),
      body: AuthPageLayout(
        childWidget: Center(
          child: Container(
            width: 500,
            height: 500,
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: const BoxDecoration(
                color: Colors.transparent, shape: BoxShape.rectangle),
            // border: Border.all(color: Colors.grey)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                ),
                // TextField(
                //   controller: emailController,
                //   decoration: InputDecoration(
                //       // contentPadding: EdgeInsets.all(50),
                //       hintText: 'Email',
                //       border: OutlineInputBorder(
                //           borderSide: BorderSide(color: Colors.white),
                //           borderRadius: BorderRadius.circular(10))),
                // ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: passwordController,
                  hintText: "password",
                  obscureText: true,
                ),
                // TextField(
                //   controller: passwordController,
                //   decoration: InputDecoration(
                //       // contentPadding: EdgeInsets.fromLTRB(),
                //       hintText: 'Password',
                //       border: OutlineInputBorder(
                //           borderSide: BorderSide(color: Colors.white),
                //           borderRadius: BorderRadius.circular(10))),
                // ),
                const SizedBox(
                  height: 15,
                ),
                AuthButton(
                    function: () async {
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();

                      if (email.isNotEmpty && password.isNotEmpty) {
                        setState(() {
                          isloading = true;
                        });
                        String res = await UserAuthentication()
                            .loginUser(email: email, password: password);

                        // await authenticationotifier.login(
                        //     email: email,
                        //     password: password,
                        //     context: context);
                        if (res == "success") {
                          currentUserDetails();
                          // Navigator.of(context).pushNamed(AppRoutes.Myhomepage);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const ResponsiveLayout(
                              webScreenLayout: WebScreen(),
                              mobileScreenLayout: MobileScreen(),
                            ),
                          ));
                        } else {
                          showSnackBar(context, res);
                        }
                      } else {
                        showSnackBar(context, "Fill the credentials");
                      }
                      setState(() {
                        isloading = false;
                      });
                    },
                    text: "Login",
                    backgroundcolor: Colors.black87,
                    textColor: Colors.white,
                    isloading: isloading,
                    width: 250),
                const SizedBox(
                  height: 10,
                ),
                AuthButton(
                    function: () => Navigator.of(context)
                        .pushNamed(AppRoutes.PhonePageRoute),
                    text: "phone login",
                    backgroundcolor: Colors.white60,
                    textColor: Colors.deepPurple,
                    isloading: false,
                    width: 200),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.SignUpRoute);
                    },
                    child: const Text('New user? SignUp')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
