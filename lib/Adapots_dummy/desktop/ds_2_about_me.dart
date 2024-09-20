import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../statics/key_holders.dart';
import '../statics/data_values.dart';
import '../theme/app_theme.dart';
import '../widgets/button_text.dart';
import '../widgets/text_pairs.dart';
import '../widgets/container_card.dart';
import '../widgets/container_banner.dart';
import '../widgets/frame_title.dart';

class DS2AboutMe extends StatefulWidget {
  const DS2AboutMe({super.key});

  @override
  _DS2AboutMeState createState() => _DS2AboutMeState();
}

class _DS2AboutMeState extends State<DS2AboutMe>
    with SingleTickerProviderStateMixin {
  bool _isHoveredCard1 = false,
      _isHoveredCard2 = false,
      _isHoveredCard3 = false;

  Widget bio(BuildContext context) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

  Widget animatedCardHover({
    required Widget child,
    required Function(PointerEnterEvent) onEnter,
    required Function(PointerExitEvent) onExit,
    required bool isHovered,
  }) {
    return MouseRegion(
      onEnter: onEnter,
      onExit: onExit,
      child: AnimatedOpacity(
        opacity: isHovered ? 1.0 : 0.7,
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
    );
  }

  Widget titles(BuildContext context) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: animatedCardHover(
              child: ContainerCard().type1(
                title: DataValues.aboutProduct1,
                description: DataValues.aboutMeProduct1Description,
                image: 'assets/images/third-party-logistics.png',
                message: DataValues.linkedinURL.toString(),
                url: DataValues.linkedinURL,
              ),
              onEnter: (_) => setState(() {
                _isHoveredCard1 = true;
              }),
              onExit: (_) => setState(() {
                _isHoveredCard1 = false;
              }),
              isHovered: _isHoveredCard1,
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          Expanded(
            child: animatedCardHover(
              child: ContainerCard().type1(
                title: DataValues.product2,
                description: DataValues.aboutMeProduct2Description,
                image: 'assets/images/connecting farmers.png',
                message: DataValues.linkedinURL.toString(),
                url: DataValues.linkedinURL,
              ),
              onEnter: (_) => setState(() {
                _isHoveredCard2 = true;
              }),
              onExit: (_) => setState(() {
                _isHoveredCard2 = false;
              }),
              isHovered: _isHoveredCard2,
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          Expanded(
            child: animatedCardHover(
              child: ContainerCard().type1(
                title: DataValues.product3,
                description: DataValues.aboutMeProduct3Description,
                image: 'assets/images/Contract.jpg',
                message: DataValues.linkedinURL.toString(),
                url: DataValues.linkedinURL,
              ),
              onEnter: (_) => setState(() {
                _isHoveredCard3 = true;
              }),
              onExit: (_) => setState(() {
                _isHoveredCard3 = false;
              }),
              isHovered: _isHoveredCard3,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('about-me-section'),
      onVisibilityChanged: (info) {},
      child: Container(
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
      ),
    );
  }
}
