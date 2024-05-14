import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:lottie/lottie.dart';
import 'package:supplink/Providers/core/notifiers/authenticationnotifier.dart';
import 'package:provider/provider.dart';
import 'package:supplink/Authentication/authRoutes/AppRoutes.dart';
import 'package:supplink/Backend/firebase/userDeatilsmaintain.dart';

// class WelcomePage extends StatefulWidget {
//   @override
//   _WelcomePageState createState() => _WelcomePageState();
// }

// class _WelcomePageState extends State<WelcomePage>
//     with TickerProviderStateMixin {

// }

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

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
  final TextEditingController villageNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  String selectedDomain = '';
  int currentStep = 0;

  @override
  void initState() {
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
  void dispose() {
    _animationController.dispose();
    _titleAnimationController.dispose();
    super.dispose();
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
              padding: EdgeInsets.symmetric(horizontal: 400, vertical: 200),
              child: Center(
                child: Card(
                  elevation: 3,
                  color: Colors.white,
                  child: Stepper(
                    type: StepperType.horizontal,
                    currentStep: currentStep,
                    onStepContinue: currentStep < 2 ? handleContinue : null,
                    onStepCancel: handleCancel,
                    steps: [
                      Step(
                        title: Text('Step 1'),
                        isActive: currentStep >= 0,
                        state: currentStep > 0
                            ? StepState.complete
                            : StepState.indexed,
                        content: buildStepContent([
                          CustomTextField(
                            controller: usernameController,
                            hintText: 'Enter name',
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: emailController,
                            hintText: 'Enter Email',
                          ),
                          SizedBox(height: 5),
                          CustomTextField(
                            controller: passwordController,
                            hintText: 'Enter password',
                            // obscureText: true,
                          ),
                          SizedBox(height: 5),
                          CustomTextField(
                            controller: confirmPasswordController,
                            hintText: 'Reconfirm password',
                            obscureText: true,
                          ),
                        ]),
                      ),
                      Step(
                        title: Text('Step 2'),
                        isActive: currentStep >= 1,
                        state: currentStep > 1
                            ? StepState.complete
                            : StepState.indexed,
                        content: buildStepContent([
                          CustomTextField(
                            controller: villageNameController,
                            hintText: 'Enter Village Name',
                          ),
                          SizedBox(height: 5),
                          CustomTextField(
                            controller: locationController,
                            hintText: 'Enter Location Pin',
                          ),
                          SizedBox(height: 5),
                          CustomTextField(
                            controller: phoneNoController,
                            hintText: 'Enter PhoneNo',
                          ),
                          SizedBox(height: 5),
                        ]),
                      ),
                      Step(
                        title: Text('Step 3'),
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
                          SizedBox(height: 45),
                          ElevatedButton(
                            onPressed: () async {
                              String email = emailController.text;
                              String password = passwordController.text;
                              String confirmPassword =
                                  confirmPasswordController.text;
                              String location = locationController.text;
                              String phoneNo = phoneNoController.text;
                              String village = villageNameController.text;
                              String username = usernameController.text;
                              String domain = selectedDomain;

                              try {
                                if (email.isNotEmpty &&
                                    password.isNotEmpty &&
                                    confirmPassword.isNotEmpty &&
                                    location.isNotEmpty &&
                                    domain.isNotEmpty) {
                                  dynamic response =
                                      await authenticationotifier.signup(
                                    email: email,
                                    password: password,
                                    confirmpassword: confirmPassword,
                                    displayName: username,
                                  );

                                  if (response[0] == 'signup') {
                                    UserDetailsTable userdetails =
                                        UserDetailsTable();
                                    String user_id = await userdetails
                                        .generateUserId(username);
                                    userdetails.addUser(
                                      response[1],
                                      username,
                                      email,
                                      int.parse(location),
                                      int.parse(phoneNo),
                                      domain,
                                      village,
                                      context,
                                      user_id,
                                    );
                                    userdetails.addUsersInDomaines(
                                        response[1], domain, username);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(response[0])),
                                    );

                                    Navigator.of(context)
                                        .pushNamed(AppRoutes.LoginRoute);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(response[0])),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Fill the credentials')),
                                  );
                                }
                              } catch (e) {
                                print('signup error: $e');
                              }
                            },
                            style: ButtonStyle(
                              side: MaterialStatePropertyAll(
                                BorderSide(color: Colors.black),
                              ),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              fixedSize: const MaterialStatePropertyAll(
                                Size.fromWidth(250),
                              ),
                              padding: MaterialStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 20),
                              ),
                            ),
                            child: Text('Signup'),
                          ),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.LoginRoute);
                            },
                            child: Text('Already have an account? Login'),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
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

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText && !isPasswordVisible,
      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding: EdgeInsets.only(left: 5),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }
}

class DomainSelectorList extends StatefulWidget {
  final ValueChanged<String> onItemSelected;

  const DomainSelectorList({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  State<DomainSelectorList> createState() => _DomainSelectorListState();
}

class _DomainSelectorListState extends State<DomainSelectorList> {
  List<String> domainList = ['Farmer', 'Manufacture', 'Retailer', 'Supplier'];
  String itemSelected = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: DropdownSearch<String>(
        items: domainList,
        popupProps: PopupProps.menu(
          showSearchBox: true,
        ),
        dropdownButtonProps: DropdownButtonProps(
          color: Colors.blue,
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          textAlignVertical: TextAlignVertical.center,
          dropdownSearchDecoration: InputDecoration(
            labelText: "Domain",
            hintText: "Domain in menu mode",
            border: OutlineInputBorder(),
          ),
        ),
        onChanged: (value) {
          setState(() {
            itemSelected = value.toString();
            widget.onItemSelected(itemSelected);
          });
        },
        selectedItem: itemSelected,
      ),
    );
  }
}
