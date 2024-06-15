import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:supplink/Home/widgets/main_app_bar.dart';
import 'package:supplink/Routes/routes.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  // ignore: unused_field
  late Animation<double> _animation;
  late AnimationController _titleAnimationController;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
      duration: const Duration(milliseconds: 4000),
    );

    _titleAnimation = Tween<double>(begin: 1, end: 1).animate(
      CurvedAnimation(
        parent: _titleAnimationController,
        curve: Curves.easeInOut,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const MainAppBar(),
      body: Stack(
        children: [
          Lottie.asset(
            'assets/Animation - 1711652608670.json',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color.fromARGB(255, 8, 132, 163).withOpacity(0.9),
                  const Color.fromARGB(255, 52, 82, 132).withOpacity(0.4),
                  const Color.fromARGB(255, 19, 108, 135).withOpacity(0.1),
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
                'assets/AppTitle.json',
                width: 150,
                height: 80,
                repeat: false,
                animate: true,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(_animationController),
                  child: Text(
                    'Efficient and Collaborating Supply Chain Management  \n       Minimizing loss, Maximizing Efficiency',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ScaleTransition(
                  scale: _animationController,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      // primary: Colors.orange,
                      // onPrimary: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: InkWell(
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.loginRoute),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
