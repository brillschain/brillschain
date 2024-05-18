import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:supplink/Routes/Routes.dart';

class AuthPageLayout extends StatefulWidget {
  final Widget childWidget;

  const AuthPageLayout({
    super.key,
    required this.childWidget,
  });

  @override
  State<AuthPageLayout> createState() => _AuthPageLayoutState();
}

class _AuthPageLayoutState extends State<AuthPageLayout>
    with TickerProviderStateMixin {
  // late Animation<double> _animation;
  late AnimationController _titleAnimationController;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    super.initState();
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
  void dispose() {
    super.dispose();
    _titleAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.rectangle,
            ),
            child: widget.childWidget,
          ),
        ),
      ],
    );
  }
}
