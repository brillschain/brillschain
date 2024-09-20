import 'package:flutter/material.dart';

import '../statics/data_values.dart';
import '../statics/key_holders.dart';
import '../theme/app_theme.dart';
import '../widgets/container_banner.dart';
import '../widgets/container_card.dart';
import '../widgets/frame_title.dart';

class DS5Volunteering extends StatelessWidget {
  const DS5Volunteering({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: KeyHolders.volunteeringKey,
      // color: AppThemeData.backgroundGrey,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FrameTitle(
                title: DataValues.volunteeringTitle,
                description: DataValues.volunteeringDescription),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ContainerCard().type1(
                    title: DataValues.Values1,
                    description: DataValues.ValuesDesp1,
                    image: 'assets/images/Transparency.jpg',
                    message: DataValues.linkedinURL.toString(),
                    url: DataValues.linkedinURL,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                Expanded(
                  child: ContainerCard().type1(
                    title: DataValues.Values2,
                    description: DataValues.ValuesDesp2,
                    image: 'assets/images/Innovation.jpg',
                    message: DataValues.linkedinURL.toString(),
                    url: DataValues.linkedinURL,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                Expanded(
                  child: ContainerCard().type1(
                    title: DataValues.Values3,
                    description: DataValues.ValuesDesp3,
                    image: 'assets/images/Sustainabilty.jpg',
                    message: DataValues.linkedinURL.toString(),
                    url: DataValues.linkedinURL,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                Expanded(
                  child: ContainerCard().type1(
                    title: DataValues.Values4,
                    description: DataValues.aboutMeProduct2Description,
                    image: 'assets/images/Collborate.jpg',
                    message: DataValues.linkedinURL.toString(),
                    url: DataValues.linkedinURL,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
