import 'package:flutter/material.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:lottie/lottie.dart';
import 'package:supplink/Backend/auth/user_auth.dart';
import 'package:supplink/Home/widgets/auth_button.dart';
import 'package:supplink/Home/widgets/auth_layout.dart';
import 'package:supplink/Home/widgets/auth_text_field.dart';
import 'package:supplink/Home/widgets/domain_selector_list.dart';
import 'package:supplink/Home/widgets/main_app_bar.dart';
import 'package:supplink/Routes/routes.dart';
import 'package:supplink/utils/snackbars.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  late AnimationController _animationController;
  // ignore: unused_field
  late Animation<double> _animation;
  late AnimationController _titleAnimationController;
  late Animation<double> _titleAnimation;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  String selectedDomain = '';
  int currentStep = 0;
  bool isLoading = false;
  @override
  // void initState() {
  //   super.initState();
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 1500),
  //   );
  //   _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
  //     CurvedAnimation(
  //       parent: _animationController,
  //       curve: Curves.easeInOut,
  //     ),
  //   );
  //   _animationController.forward();

  //   _titleAnimationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 4000),
  //   );

  //   _titleAnimation = Tween<double>(begin: 0, end: 1).animate(
  //     CurvedAnimation(
  //       parent: _titleAnimationController,
  //       curve: Curves.easeOutSine,
  //     ),
  //   );

  //   _titleAnimationController.addStatusListener((status) {
  //     if (status == AnimationStatus.completed) {
  //       _titleAnimationController.stop();
  //     }
  //   });

  //   _titleAnimationController.forward();
  // }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _titleAnimationController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addressController.dispose();
    locationController.dispose();
    phoneNoController.dispose();
  }

  final UserAuthentication authSignUp = UserAuthentication();
  Future<String> signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String response = await authSignUp.signUpUser(
        name: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        domain: selectedDomain,
        address: addressController.text.trim(),
        phoneno: int.parse(phoneNoController.text.trim()),
        username: '',
        pincode: int.parse(locationController.text.trim()));
    setState(() {
      isLoading = false;
    });
    return response;
  }

  Widget buildStepContent(List<Widget> stepFields) {
    return Column(
      children: stepFields,
    );
  }

  void handleContinue() {
    setState(() {
      currentStep += currentStep < 2 ? 1 : 0;
    });
  }

  void handleCancel() {
    setState(() {
      currentStep = currentStep > 0 ? currentStep - 1 : 0;
    });
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
              margin: const EdgeInsets.only(top: 50),
              decoration: const BoxDecoration(
                  color: Colors.transparent, shape: BoxShape.rectangle),
              height: 500,
              width: 500,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Center(
                child: Theme(
                  data: ThemeData(
                    canvasColor: const Color.fromARGB(253, 102, 216, 244)
                        .withOpacity(0.3),
                    // colorScheme: Theme.of(context).colorScheme.copyWith(
                    //       primary: Colors.green,
                    //       background: Colors.red,
                    //       secondary: Colors.green,
                    //     ),
                  ),
                  child: Stepper(
                    type: StepperType.horizontal,
                    currentStep: currentStep,
                    onStepContinue: currentStep < 2 ? handleContinue : null,
                    onStepCancel: handleCancel,
                    steps: [
                      Step(
                        title: const Text('Step 1'),
                        isActive: currentStep >= 0,
                        state: currentStep > 0
                            ? StepState.complete
                            : StepState.indexed,
                        content: buildStepContent([
                          CustomTextField(
                            controller: usernameController,
                            hintText: 'Name',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: emailController,
                            hintText: 'Email',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: passwordController,
                            hintText: 'password',
                            // obscureText: true,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: confirmPasswordController,
                            hintText: 'Reconfirm password',
                            obscureText: true,
                          ),
                        ]),
                      ),
                      Step(
                        title: const Text('Step 2'),
                        isActive: currentStep >= 1,
                        state: currentStep > 1
                            ? StepState.complete
                            : StepState.indexed,
                        content: buildStepContent([
                          CustomTextField(
                            controller: addressController,
                            hintText: 'Address',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: locationController,
                            hintText: 'pincode',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: phoneNoController,
                            hintText: 'PhoneNo',
                          ),
                          const SizedBox(height: 10),
                        ]),
                      ),
                      Step(
                        title: const Text('Step 3'),
                        isActive: currentStep >= 2,
                        state: currentStep > 2
                            ? StepState.complete
                            : StepState.indexed,
                        content: buildStepContent([
                          DomainSelectorList(
                            onItemSelected: (domain) {
                              setState(() {
                                selectedDomain = domain;
                              });
                            },
                          ),
                          const SizedBox(height: 45),
                          AuthButton(
                            function: () async {
                              String res = await signUpUser();
                              if (res == 'success') {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.myhomepage);
                              } else {
                                showSnackBar(context, res);
                              }
                            },
                            text: 'Signup',
                            backgroundcolor: Colors.white60,
                            textColor: Colors.deepPurple,
                            isloading: isLoading,
                            width: 250,
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.loginRoute);
                            },
                            child: const Text('Already have an account? Login'),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildHeaderButton(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

// ElevatedButton authButton(
//     Authenticationotifier authenticationotifier, BuildContext context) {
//   return ElevatedButton(
//     onPressed: () async {},
//     style: ButtonStyle(
//       side: MaterialStatePropertyAll(
//         BorderSide(color: Colors.black),
//       ),
//       shape: MaterialStatePropertyAll(
//         RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       fixedSize: const MaterialStatePropertyAll(
//         Size.fromWidth(250),
//       ),
//       padding: MaterialStatePropertyAll(
//         EdgeInsets.symmetric(vertical: 20),
//       ),
//     ),
//     child: Text('Signup'),
//   );
// }


 // ElevatedButton(
                          //   onPressed: () async {
                          //     String email = emailController.text;
                          //     String password = passwordController.text;
                          //     String confirmPassword =
                          //         confirmPasswordController.text;
                          //     String location = locationController.text;
                          //     String phoneNo = phoneNoController.text;
                          //     String village = addressController.text;
                          //     String username = usernameController.text;
                          //     String domain = selectedDomain;

                          //     try {
                          //       if (email.isNotEmpty &&
                          //           password.isNotEmpty &&
                          //           confirmPassword.isNotEmpty &&
                          //           location.isNotEmpty &&
                          //           domain.isNotEmpty) {
                          //         dynamic response =
                          //             await authenticationotifier.signup(
                          //           email: email,
                          //           password: password,
                          //           confirmpassword: confirmPassword,
                          //           displayName: username,
                          //         );

                          //         if (response[0] == 'signup') {
                          //           UserDetailsTable userdetails =
                          //               UserDetailsTable();
                          //           String user_id = await userdetails
                          //               .generateUserId(username);
                          //           userdetails.addUser(
                          //             response[1],
                          //             username,
                          //             email,
                          //             int.parse(location),
                          //             int.parse(phoneNo),
                          //             domain,
                          //             village,
                          //             context,
                          //             user_id,
                          //           );
                          //           userdetails.addUsersInDomaines(
                          //               response[1], domain, username);

                          //           ScaffoldMessenger.of(context).showSnackBar(
                          //             SnackBar(content: Text(response[0])),
                          //           );

                          //           Navigator.of(context)
                          //               .pushNamed(AppRoutes.LoginRoute);
                          //         } else {
                          //           ScaffoldMessenger.of(context).showSnackBar(
                          //             SnackBar(content: Text(response[0])),
                          //           );
                          //         }
                          //       } else {
                          //         ScaffoldMessenger.of(context).showSnackBar(
                          //           SnackBar(
                          //               content: Text('Fill the credentials')),
                          //         );
                          //       }
                          //     } catch (e) {
                          //       print('signup error: $e');
                          //     }
                          //   },
                          //   style: ButtonStyle(
                          //     side: MaterialStatePropertyAll(
                          //       BorderSide(color: Colors.black),
                          //     ),
                          //     shape: MaterialStatePropertyAll(
                          //       RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //     ),
                          //     fixedSize: const MaterialStatePropertyAll(
                          //       Size.fromWidth(250),
                          //     ),
                          //     padding: MaterialStatePropertyAll(
                          //       EdgeInsets.symmetric(vertical: 20),
                          //     ),
                          //   ),
                          //   child: Text('Signup'),
                          // ),
