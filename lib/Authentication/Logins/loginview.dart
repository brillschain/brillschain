import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
// import 'package:supplink/Backend/firebase/userDeatilsmaintain.dart';
import 'package:supplink/Providers/core/notifiers/authenticationnotifier.dart';
import 'package:supplink/Authentication/authRoutes/AppRoutes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    final Authenticationotifier authenticationotifier =
        Provider.of<Authenticationotifier>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            // FadeTransition(
            //   opacity: _animation,
            //   child: Text(
            //     'Wave Technologies',
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 24,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 110, top: 30),
              child: FadeTransition(
                opacity: _titleAnimation,
                child: Text(
                  'Wave Supply chain Solutions',
                  style: TextStyle(
                    color: Color.fromARGB(255, 238, 170, 245),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          _buildHeaderButton('Home'),
          _buildHeaderButton('Services'),
          _buildHeaderButton('Featuers'),
          _buildHeaderButton('Contact Us'),
          SizedBox(width: 16),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.LoginRoute);
            },
            child: Text(
              'Login',
              style: TextStyle(color: Colors.lightGreen),
            ),
          ),
          SizedBox(width: 8),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.SignUpRoute);
            },
            child: Text(
              'Sign up',
              style: TextStyle(color: Colors.lightGreen),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // Lottie.asset(
          //   'assets/Animation - 1711652608670.json',
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 8, 132, 163).withOpacity(0.9),
                  Color.fromARGB(255, 52, 82, 132).withOpacity(0.4),
                  Color.fromARGB(255, 19, 108, 135).withOpacity(0.1),
                ],
              ),
            ),
          ),
          Positioned(
            top: 4.0,
            left: 4.0,
            child: FadeTransition(
              opacity: _titleAnimation,
              child: Lottie.asset(
                'AppTitle.json',
                width: 150,
                height: 80,
                repeat: false,
                animate: true,
              ),
            ),
          ),

          Center(
            child: Container(
              width: 500,
              height: 500,
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  color: Colors.transparent, shape: BoxShape.rectangle),
              // border: Border.all(color: Colors.grey)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        // contentPadding: EdgeInsets.all(50),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        // contentPadding: EdgeInsets.fromLTRB(),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();

                        if (email.isNotEmpty && password.isNotEmpty) {
                          await authenticationotifier.login(
                              email: email,
                              password: password,
                              context: context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Fill the credentials')));
                        }
                      },
                      style: ButtonStyle(
                          side: MaterialStatePropertyAll(
                              BorderSide(color: Colors.black)),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          fixedSize: const MaterialStatePropertyAll(
                              Size.fromWidth(250)),
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 20),
                          ),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black87)),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 16),
                      )),
                  SizedBox(
                    height: 10,
                  ),

                  //
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.PhonePageRoute);
                      },
                      style: ButtonStyle(
                          side: MaterialStatePropertyAll(
                              BorderSide(color: Colors.black)),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          fixedSize: const MaterialStatePropertyAll(
                              Size.fromWidth(200)),
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 20),
                          )),
                      child: Text('Phone login')),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.SignUpRoute);
                      },
                      child: Text('New user? SignUp')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}















// Center(
//         child: Container(
//           width: 500,
//           height: 500,
//           margin: const EdgeInsets.all(15.0),
//           padding: const EdgeInsets.all(3.0),
//           decoration:
//               BoxDecoration(color: Colors.white, shape: BoxShape.rectangle),
//           // border: Border.all(color: Colors.grey)),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                     // contentPadding: EdgeInsets.all(50),
//                     hintText: 'Email',
//                     border: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.black),
//                         borderRadius: BorderRadius.circular(10))),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               TextField(
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                     // contentPadding: EdgeInsets.fromLTRB(),
//                     hintText: 'Password',
//                     border: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.black),
//                         borderRadius: BorderRadius.circular(10))),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               ElevatedButton(
//                   onPressed: () async {
//                     String email = emailController.text.trim();
//                     String password = passwordController.text.trim();

//                     if (email.isNotEmpty && password.isNotEmpty) {
//                       await authenticationotifier.login(
//                           email: email, password: password, context: context);
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Fill the credentials')));
//                     }
//                   },
//                   style: ButtonStyle(
//                       side: MaterialStatePropertyAll(
//                           BorderSide(color: Colors.black)),
//                       shape: MaterialStatePropertyAll(RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10))),
//                       fixedSize:
//                           const MaterialStatePropertyAll(Size.fromWidth(250)),
//                       padding: MaterialStatePropertyAll(
//                         EdgeInsets.symmetric(vertical: 20),
//                       ),
//                       backgroundColor:
//                           MaterialStatePropertyAll(Colors.black87)),
//                   child: Text(
//                     'Login',
//                     style: TextStyle(fontSize: 16),
//                   )),
//               SizedBox(
//                 height: 10,
//               ),

//               //
//               ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushNamed(AppRoutes.PhonePageRoute);
//                   },
//                   style: ButtonStyle(
//                       side: MaterialStatePropertyAll(
//                           BorderSide(color: Colors.black)),
//                       shape: MaterialStatePropertyAll(RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10))),
//                       fixedSize:
//                           const MaterialStatePropertyAll(Size.fromWidth(200)),
//                       padding: MaterialStatePropertyAll(
//                         EdgeInsets.symmetric(vertical: 20),
//                       )),
//                   child: Text('Phone login')),
//               SizedBox(
//                 height: 10,
//               ),
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pushNamed(AppRoutes.SignUpRoute);
//                   },
//                   child: Text('New user? SignUp')),
//             ],
//           ),
//         ),
//       ),











