import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../statics/data_values.dart';
import '../statics/key_holders.dart';
import '../widgets/container_card.dart';
import '../widgets/frame_title.dart';

class DS3Education extends StatefulWidget {
  const DS3Education({super.key});

  @override
  _DS3EducationState createState() => _DS3EducationState();
}

class _DS3EducationState extends State<DS3Education>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _visible = false;
  bool _isHoveredCard1 = false, _isHoveredCard2 = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.7,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.5 && !_visible) {
      _controller.forward();
      setState(() {
        _visible = true;
      });
    } else if (info.visibleFraction <= 0.5 && _visible) {
      _controller.reverse();
      setState(() {
        _visible = false;
      });
    }
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0),
        child: child,
      ),
    );
  }

  // Widget titles(BuildContext context) {
  //   return ScaleTransition(
  //     scale: _scaleAnimation,
  //     child: FadeTransition(
  //       opacity: _fadeAnimation,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Expanded(
  //             child: animatedCardHover(
  //               child: ContainerCard().type2(
  //                 image: 'mms',
  //                 title: DataValues.educationOrg1Title,
  //                 values: [
  //                   DataValues.educationOrg1Course1Name,
  //                   DataValues.educationOrg1Course1Grade,
  //                   DataValues.educationOrg1Course1Year,
  //                   DataValues.educationOrg1Course2Name,
  //                   DataValues.educationOrg1Course2Grade,
  //                   DataValues.educationOrg1Course2Year,
  //                   DataValues.educationOrg1Course3Name,
  //                   DataValues.educationOrg1Course3Year,
  //                   DataValues.educationOrg1Course3Year2,
  //                 ],
  //                 message: DataValues.linkedinURL.toString(),
  //                 url: DataValues.linkedinURL,
  //               ),
  //               onEnter: (_) => setState(() {
  //                 _isHoveredCard1 = true;
  //               }),
  //               onExit: (_) => setState(() {
  //                 _isHoveredCard1 = false;
  //               }),
  //               isHovered: _isHoveredCard1,
  //             ),
  //           ),
  //           SizedBox(width: MediaQuery.of(context).size.width * 0.05),
  //           Expanded(
  //             child: animatedCardHover(
  //               child: ContainerCard().type2(
  //                 image: 'nibm',
  //                 title: DataValues.educationOrg2Title,
  //                 values: [
  //                   DataValues.educationOrg2Course1Name,
  //                   DataValues.educationOrg2Course1Grade,
  //                   DataValues.educationOrg2Course1Year,
  //                   DataValues.educationOrg2Course2Name,
  //                   DataValues.educationOrg2Course2Grade,
  //                   DataValues.educationOrg2Course2Year,
  //                   DataValues.educationOrg2Course3Name,
  //                   DataValues.educationOrg2Course3Grade,
  //                   DataValues.educationOrg2Course3Year,
  //                 ],
  //                 message: DataValues.linkedinURL.toString(),
  //                 url: DataValues.linkedinURL,
  //               ),
  //               onEnter: (_) => setState(() {
  //                 _isHoveredCard2 = true;
  //               }),
  //               onExit: (_) => setState(() {
  //                 _isHoveredCard2 = false;
  //               }),
  //               isHovered: _isHoveredCard2,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget titles(BuildContext context) {
    return SizedBox(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: animatedCardHover(
                  child: ContainerCard().type1(
                    title: DataValues.aboutProduct4,
                    description: DataValues.aboutMeProduct1Description,
                    image:
                        'assets/images/social-media-network-connection-concept_MkAvmiid_SB_PM.jpg',
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
                    image: 'assets/images/AIShelf.jpg',
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('education-section'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: Container(
        key: KeyHolders.educationKey,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FrameTitle(
                title: DataValues.features,
                description: DataValues.educationDescription,
              ),
              titles(context),
              const SizedBox(height: 80.0),
            ],
          ),
        ),
      ),
    );
  }
}
