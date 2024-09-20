// // import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:supplink/Adapots_dummy/desktop/ds_2_about_me.dart';
// import 'package:supplink/Adapots_dummy/desktop/ds_3_education.dart';
// import 'package:supplink/Adapots_dummy/desktop/ds_4_experience.dart';
// import 'package:supplink/Adapots_dummy/desktop/ds_5_volunteering.dart';
// import 'package:supplink/Adapots_dummy/desktop/ds_6_technotes.dart';
// import 'package:supplink/Adapots_dummy/desktop/ds_7_contact.dart';
// import 'package:supplink/Adapots_dummy/desktop/ds_8_footer.dart';
// import 'package:supplink/Adapots_dummy/mobile/ms_1_header.dart';
// import 'package:supplink/Adapots_dummy/mobile/ms_2_about_me.dart';
// import 'package:supplink/Adapots_dummy/mobile/ms_3_education.dart';
// import 'package:supplink/Adapots_dummy/mobile/ms_4_experience.dart';
// import 'package:supplink/Adapots_dummy/mobile/ms_5_volunteering.dart';
// import 'package:supplink/Adapots_dummy/mobile/ms_6_technotes.dart';
// import 'package:supplink/Adapots_dummy/mobile/ms_7_contact.dart';
// import 'package:supplink/Adapots_dummy/mobile/ms_8_footer.dart';
// import 'package:supplink/Adapots_dummy/theme/responsive_screen_provider.dart';
// import 'package:supplink/Adapots_dummy/widgets/nav_bar.dart';
// import 'package:supplink/Routes/Routes.dart';

// class WelcomePage extends StatefulWidget {
//   const WelcomePage({super.key});

//   @override
//   _WelcomePageState createState() => _WelcomePageState();
// }

// class _WelcomePageState extends State<WelcomePage>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   late AnimationController _titleAnimationController;
//   late Animation<double> _titleAnimation;

//   bool _showBackToTopButton = false;
//   late ScrollController _scrollController;

//   @override
//   void initState() {
//     _scrollController = ScrollController()
//       ..addListener(() {
//         setState(() {
//           if (_scrollController.offset >= 300) {
//             _showBackToTopButton = true;
//           } else {
//             _showBackToTopButton = false;
//           }
//         });
//       });

//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//     _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//     _animationController.forward();

//     _titleAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 4000),
//     );

//     _titleAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _titleAnimationController,
//         curve: Curves.easeOutSine,
//       ),
//     );

//     _titleAnimationController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _titleAnimationController.stop();
//       }
//     });

//     _titleAnimationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _titleAnimationController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _scrollToTop() {
//     _scrollController.animateTo(0,
//         duration: const Duration(milliseconds: 1000), curve: Curves.easeInOut);
//   }

//   Widget desktopUI() {
//     return Column(
//       children: [
//         Stack(
//           children: [
//             // Container(
//             //   height: MediaQuery.of(context).size.height,
//             //   decoration: BoxDecoration(
//             //     gradient: LinearGradient(
//             //       begin: Alignment.topCenter,
//             //       end: Alignment.bottomCenter,
//             //       colors: [
//             //         const Color.fromARGB(255, 8, 132, 163).withOpacity(0.9),
//             //         const Color.fromARGB(255, 52, 82, 132).withOpacity(0.4),
//             //         const Color.fromARGB(255, 19, 108, 135).withOpacity(0.1),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             Positioned.fill(
//               child: Lottie.asset(
//                 'assets/Animation - 1711652608670.json',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Positioned(
//               top: 4.0,
//               left: 4.0,
//               child: FadeTransition(
//                 opacity: _titleAnimation,
//                 child: Lottie.asset(
//                   'assets/AppTitle.json',
//                   width: 150,
//                   height: 80,
//                   repeat: false,
//                   animate: true,
//                 ),
//               ),
//             ),
//             Center(
//               child: Container(
  
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 height: MediaQuery.of(context).size.height,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SlideTransition(
//                       position: Tween<Offset>(
//                         begin: const Offset(1.0, 0.0),
//                         end: const Offset(0.0, 0.0),
//                       ).animate(_animationController),
//                       child: Text(
//                         'Efficient and Collaborating Supply Chain Management\nMinimizing loss, Maximizing Efficiency',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1.5,
//                           shadows: [
//                             Shadow(
//                               color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
//                               blurRadius: 4,
//                               offset: const Offset(2, 2),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     ScaleTransition(
//                       scale: _animationController,
//                       child: ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: InkWell(
//                           onTap: () =>
//                               Navigator.of(context).pushNamed(AppRoutes.LoginRoute),
//                           child: const Text(
//                             'Get Started',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         ListView(
//           // shrinkWrap: true,
//           physics: const ClampingScrollPhysics(),
//           children: [
          
//             DS2AboutMe(),
//             DS3Education(),
//             DS4Experience(),
//             DS5Volunteering(),
//             DS6TechNotes(),
//             DS7Contact(),
//             DS8Footer(),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget mobileUI() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             const Color.fromARGB(255, 8, 132, 163).withOpacity(0.9),
//             const Color.fromARGB(255, 52, 82, 132).withOpacity(0.4),
//             const Color.fromARGB(255, 19, 108, 135).withOpacity(0.1),
//           ],
//         ),
//       ),
//       child: ListView(
//         shrinkWrap: true,
//         physics: const ClampingScrollPhysics(),
//         children: const [
//           MS1Header(),
//           MS2AboutMe(),
//           MS3Education(),
//           MS4Experience(),
//           MS5Volunteering(),
//           MS6TechNotes(),
//           MS7Contact(),
//           MS8Footer(),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: ResponsiveScreenProvider.isDesktopScreen(context)
//           ? null
//           : AppBar(elevation: 0.0),
//       drawer: ResponsiveScreenProvider.isDesktopScreen(context)
//           ? null
//           : NavBar().mobileNavBar(),
//       body: SingleChildScrollView(
//         controller: _scrollController,
//         physics: const BouncingScrollPhysics(),
//         child: ResponsiveScreenProvider.isDesktopScreen(context)
//             ? desktopUI()
//             : mobileUI(),
//       ),
//       floatingActionButton: _showBackToTopButton
//           ? FloatingActionButton(
//               onPressed: _scrollToTop,
//               tooltip: 'Scroll to Top',
//               child: const Icon(Icons.arrow_upward),
//             )
//           : null,
//     );
//   }
// }
