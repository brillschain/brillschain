import 'package:flutter/material.dart';

import '../statics/data_values.dart';
import '../widgets/social_profiles.dart';

class MS1Header extends StatelessWidget {
  const MS1Header({super.key});

  List<Widget> headerData() {
    return [
      Image.asset('assets/images/logo.png', height: 250.0, width: 250.0),
      const SizedBox(height: 40.0),
      const Column(
        children: [
          SelectableText(
            DataValues.headerGreetings,
            // style: AppThemeData.darkTheme.textTheme.headlineSmall,
          ),
          SelectableText(
            DataValues.headerName,
            // style: AppThemeData.darkTheme.textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          SelectableText(
            DataValues.headerTitle,
            // style: AppThemeData.darkTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 20.0),
          SocialProfiles(),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: AppThemeData.backgroundBlack,
      child: Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: headerData(),
              ),
              const SizedBox(height: 40.0),
            ],
          )),
    );
  }
}
