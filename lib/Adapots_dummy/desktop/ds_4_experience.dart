import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../statics/data_values.dart';
import '../statics/key_holders.dart';
import '../theme/app_theme.dart';
import '../widgets/container_card.dart';
import '../widgets/container_banner.dart';
import '../widgets/frame_title.dart';

class DS4Experience extends StatefulWidget {
  const DS4Experience({super.key});

  @override
  _DS4ExperienceState createState() => _DS4ExperienceState();
}

class _DS4ExperienceState extends State<DS4Experience>
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

  Widget _animatedCardHover({
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

  Widget _buildCard(String image, String title, String role, String years,
      String values, bool isHovered, ValueChanged<bool> onHoverChange) {
    return Expanded(
      child: _animatedCardHover(
        child: ContainerCard().type3(
          image: image,
          title: title,
          role: role,
          years: years,
          values: values,
          message: DataValues.linkedinURL.toString(),
          url: DataValues.linkedinURL,
          isButtonEnabled: true,
        ),
        onEnter: (_) => setState(() => onHoverChange(true)),
        onExit: (_) => setState(() => onHoverChange(false)),
        isHovered: isHovered,
      ),
    );
  }

  // Widget _titles(BuildContext context) {
  //   return ScaleTransition(
  //     scale: _scaleAnimation,
  //     child: FadeTransition(
  //       opacity: _fadeAnimation,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _buildCard(
  //             'dileepabandara_dev',
  //             DataValues.experienceOrg1Title,
  //             DataValues.experienceOrg1Role,
  //             DataValues.experienceOrg1Years,
  //             DataValues.experienceOrg1Vales,
  //             _isHoveredCard1,
  //             (hovered) => _isHoveredCard1 = hovered,
  //           ),
  //           SizedBox(width: MediaQuery.of(context).size.width * 0.05),
  //           _buildCard(
  //             'ddstechvira',
  //             DataValues.experienceOrg2Title,
  //             DataValues.experienceOrg2Role,
  //             DataValues.experienceOrg2Years,
  //             DataValues.experienceOrg2Vales,
  //             _isHoveredCard2,
  //             (hovered) => _isHoveredCard2 = hovered,
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
                child: _animatedCardHover(
                  child: ContainerCard().type1(
                    title: DataValues.vision1,
                    description: DataValues.vsision1Descp,
                    image: 'assets/images/EnhanceSpplyChainTransperency.jpg',
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
                child: _animatedCardHover(
                  child: ContainerCard().type1(
                    title: DataValues.vision2,
                    description: DataValues.vsision2Descp,
                    image: 'assets/images/reducewastae.jpg',
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
                child: _animatedCardHover(
                  child: ContainerCard().type1(
                    title: DataValues.vision3,
                    description: DataValues.vsision3Descp,
                    image: 'assets/images/enhanced_data_driven_insights.jpg',
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
                child: _animatedCardHover(
                  child: ContainerCard().type1(
                    title: DataValues.vision4,
                    description: DataValues.vsisio4Descp,
                    image: 'assets/images/sustainability_growth.jpg',
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
      key: const Key('experience-section'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: Container(
        key: KeyHolders.experienceKey,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FrameTitle(
                title: DataValues.experienceTitle,
                description: DataValues.experienceDescription,
              ),
              titles(context),
              const SizedBox(height: 80.0),
              // Center(
              //   child: ContainerBanner().type1(
              //     isDesktop: true,
              //     title1: DataValues.experienceBanner,
              //     title2: DataValues.experienceBannerTitle,
              //     description: DataValues.experienceBannerWeb,
              //     image: 'logo',
              //     message: 'View Toolkit',
              //     url: DataValues.toolkitURL,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
