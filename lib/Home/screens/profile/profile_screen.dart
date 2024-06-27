// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:supplink/Providers/user_provider.dart';
import 'package:supplink/models/user_model.dart';
import '../user_contracts_stasts/contract_stats.dart';
import 'widget/custom_button.dart';
import 'widget/data_column.dart';
import 'widget/details_row.dart';

class ProfilePageview extends StatelessWidget {
  final String uid;
  const ProfilePageview({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(width: 10),
            Column(
              children: [
                ProfileCard(),
                SizedBox(
                  height: 16,
                ),
                StatisticsSection(),
              ],
            ),
            SizedBox(width: 10),
            Expanded(
              // flex: 1,
              child: ContractList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, data, _) {
      UserData userData = data.getUser;
      return Card(
        child: Stack(
          children: [
            Container(
              width: 400,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        // flex: 1,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(userData.profileUrl),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(userData.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            const Text(
                              'username',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DetailsRow(
                                icon: Icons.domain, data: userData.domain),
                            DetailsRow(
                                icon: Icons.location_on_rounded,
                                data: userData.address),
                            DetailsRow(
                                icon: Icons.phone,
                                data: userData.phoneno.toString()),
                            DetailsRow(
                              icon: Icons.email,
                              data: userData.email,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      UserDataColumn(
                        name: 'posts',
                        value: data.posts.toString(),
                      ),
                      UserDataColumn(
                        name: 'Connections',
                        value: userData.connections.length.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomProfileButton(
                        const Icon(
                          Icons.person_add,
                          color: Colors.white,
                        ),
                        function: () {},
                        text: 'Connect',
                        backgroundcolor: Colors.blue,
                        textColor: Colors.white,
                        width:
                            MediaQuery.of(context).size.width > 600 ? 150 : 120,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomProfileButton(
                        const Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        function: () {},
                        text: 'share',
                        backgroundcolor: Colors.black,
                        textColor: Colors.white,
                        width:
                            MediaQuery.of(context).size.width > 600 ? 150 : 120,
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child:
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)))
          ],
        ),
      );
    });
  }
}

class StatisticsSection extends StatefulWidget {
  const StatisticsSection({super.key});

  @override
  State<StatisticsSection> createState() => _StatisticsSectionState();
}

class _StatisticsSectionState extends State<StatisticsSection> {
  Map<String, double> dataMap = {
    "ongoing": 5,
    "completed": 10,
    "Scheduled": 6,
    "cancelled": 1,
  };
  List<Color> colorList = [
    const Color(0xff3398F6),
    const Color(0xff3EE094),
    const Color(0xffD95AF3),
    const Color(0xffFA4A42),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 400,
        child: Column(
          children: [
            const Text(
              'Contract History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                dataMap: dataMap,
                animationDuration: const Duration(milliseconds: 1000),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 6.5,
                colorList: colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
                centerText: "contracts",
                legendOptions: const LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.right,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
