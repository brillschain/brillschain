import 'package:flutter/material.dart';
import 'package:supplink/Routes/routes.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  // final VoidCallback onLoginPressed;
  // final VoidCallback onSignUpPressed;

  const MainAppBar({
    super.key,
    // required this.onLoginPressed,
    // required this.onSignUpPressed,
  });

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class _MainAppBarState extends State<MainAppBar> with TickerProviderStateMixin {
  // late AnimationController _animationController;
  // late Animation<double> _animation;
  late AnimationController _titleAnimationController;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    super.initState();

    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 1500),
    // );
    // _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
    //   CurvedAnimation(
    //     parent: _animationController,
    //     curve: Curves.easeInOut,
    //   ),
    // );
    // _animationController.forward();

    _titleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
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
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 110, top: 30),
            child: FadeTransition(
              opacity: _titleAnimation,
              child: const Text(
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
        _buildHeaderButton('Home', () {}),
        _buildHeaderButton('Services', () {}),
        _buildHeaderButton('Features', () {}),
        _buildHeaderButton('Contact Us', () {}),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.loginRoute);
          },
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.lightGreen, fontSize: 18),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.signUpRoute);
          },
          child: const Text(
            'Sign up',
            style: TextStyle(color: Colors.lightGreen, fontSize: 18),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildHeaderButton(String text, Function function) {
    return TextButton(
      onPressed: () {
        function();
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
