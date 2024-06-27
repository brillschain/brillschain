import 'package:flutter/material.dart';
import '../statics/key_holders.dart';
import '../statics/data_values.dart';
import '../widgets/text_pairs.dart';
import '../widgets/container_card.dart';
import '../widgets/frame_title.dart';

class DS2AboutMe extends StatefulWidget {
  const DS2AboutMe({super.key});

  @override
  _DS2AboutMeState createState() => _DS2AboutMeState();
}

class _DS2AboutMeState extends State<DS2AboutMe> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override

  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget bio(BuildContext context) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Expanded(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       // TextPairs().type1(
          //       //   title: DataValues.aboutMeBiographyTitle,
          //       //   description: DataValues.aboutMeBiographyDescription,
          //       // ),
          //       const SizedBox(height: 40.0),
          //       ButtonTextSmall(
          //         text: 'View Full Biography >>',
          //         message: DataValues.biographyURL.toString(),
          //         url: DataValues.biographyURL,
          //       ),
          //     ],
          //   ),
          // ),
          
          SizedBox(width: MediaQuery.of(context).size.width * 0.08),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextPairs().type1(
                  title: DataValues.aboutMeFullNameTitle,
                  description: DataValues.aboutMeFullNameDescription,
                ),
                const SizedBox(height: 30.0),
                TextPairs().type1(
                  title: DataValues.aboutMeNwITitle,
                  description: DataValues.aboutMeNwIDescription,
                ),
                const SizedBox(height: 30.0),
                TextPairs().type1(
                  title: DataValues.aboutMeFnLTitle,
                  description: DataValues.aboutMeFnLDescription,
                ),
                const SizedBox(height: 30.0),
                TextPairs().type1(
                  title: DataValues.aboutMeGenderTitle,
                  description: DataValues.aboutMeGenderDescription,
                ),
                const SizedBox(height: 30.0),
                TextPairs().type1(
                  title: DataValues.aboutMeDobTitle,
                  description: DataValues.aboutMeDobDescription,
                ),
                const SizedBox(height: 30.0),
                TextPairs().type1(
                  title: DataValues.aboutMeLanguageTitle,
                  description: DataValues.aboutMeLanguageDescription,
                ),
              ],
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.08),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextPairs().type1(
                  title: DataValues.aboutMeNationalityTitle,
                  description: DataValues.aboutMeNationalityDescription,
                ),
                const SizedBox(height: 30.0),
                TextPairs().type1(
                  title: DataValues.aboutMeLocationTitle,
                  description: DataValues.aboutMeLocationDescription,
                ),
                const SizedBox(height: 30.0),
                TextPairs().type1(
                  title: DataValues.aboutMeWorkDomainTitle,
                  description: DataValues.aboutMeWorkDomainDescription,
                ),
                const SizedBox(height: 30.0),
                TextPairs().type1(
                  title: DataValues.aboutMeHobbiesTitle,
                  description: DataValues.aboutMeHobbiesDescription,
                ),
                const SizedBox(height: 30.0),
                TextPairs().type1(
                  title: DataValues.aboutMeGoalTitle,
                  description: DataValues.aboutMeGoalDescription,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget animatedCard({required Widget child}) {
    return MouseRegion(
      onEnter: (event) => setState(() {}),
      onExit: (event) => setState(() {}),
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 200),
        tween: Tween<double>(begin: 1.0, end: 1.05),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  Widget titles(BuildContext context) {
    return SizedBox(
      child: SlideTransition(
        position: _offsetAnimation,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: animatedCard(
                child: ContainerCard().type1(
                  title: DataValues.aboutMeStudentTitle,
                  description: DataValues.aboutMeStudentDescription,
                  image: 'assets/icons/student.png',
                  message: DataValues.linkedinURL.toString(),
                  url: DataValues.linkedinURL,
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),
            Expanded(
              child: animatedCard(
                child: ContainerCard().type1(
                  title: DataValues.aboutMeDeveloperTitle,
                  description: DataValues.aboutMeDeveloperDescription,
                  image: 'assets/icons/developer.png',
                  message: DataValues.linkedinURL.toString(),
                  url: DataValues.linkedinURL,
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),
            Expanded(
              child: animatedCard(
                child: ContainerCard().type1(
                  title: DataValues.aboutMeVolunteerTitle,
                  description: DataValues.aboutMeVolunteerDescription,
                  image: 'assets/icons/volunteer.png',
                  message: DataValues.linkedinURL.toString(),
                  url: DataValues.linkedinURL,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: KeyHolders.aboutKey,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FrameTitle(
                title: DataValues.aboutMeTitle,
                description: DataValues.aboutMeDescription),
            titles(context),
            const SizedBox(height: 80.0),
          ],
          
        ),
      ),
    );
  }
}
