import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:supplink/Home/widgets/custom_button.dart';

class ProfilePageTest extends StatelessWidget {
  const ProfilePageTest({super.key});

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

class DetailsRow extends StatelessWidget {
  final IconData icon;
  final String data;
  const DetailsRow({super.key, required this.icon, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(
            width: 5,
          ),
          Text(data),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const Expanded(
                      // flex: 1,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1566438480900-0609be27a4be?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                          ),
                          Text('Name',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
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
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailsRow(icon: Icons.domain, data: 'Domain'),
                          DetailsRow(
                              icon: Icons.location_on_rounded, data: 'Address'),
                          DetailsRow(icon: Icons.phone, data: 'Phone Number'),
                          DetailsRow(icon: Icons.email, data: 'Email'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const ConnectionsData(),
                const SizedBox(height: 10),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
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
                    CustomButton(
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
              child: IconButton(onPressed: () {}, icon: const Icon(Icons.edit)))
        ],
      ),
    );
  }
}

class ConnectionsData extends StatelessWidget {
  const ConnectionsData({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CoustumColumn(
          name: 'posts',
          value: "10",
        ),
        CoustumColumn(
          name: 'Connections',
          value: "14",
        ),
        // CoustumColumn(
        //   name: 'following',
        //   value: "12",
        // ),
      ],
    );
  }
}

class CoustumColumn extends StatelessWidget {
  final String value;
  final String name;
  const CoustumColumn({super.key, required this.value, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          name,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        )
      ],
    );
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

class ContractList extends StatefulWidget {
  const ContractList({super.key});

  @override
  State<ContractList> createState() => _ContractListState();
}

class _ContractListState extends State<ContractList>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  final List<Contract> contracts = [
    Contract(
        date: '25.05.2024',
        status: 'Scheduled',
        product: 'product1',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '27.05.2024',
        status: 'Scheduled',
        product: 'product2',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '30.05.2024',
        status: 'Scheduled',
        product: 'product3',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '15.05.2024',
        status: 'Cancelled',
        product: 'product4',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '21.05.2024',
        status: 'Ongoing',
        product: 'product5',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '25.05.2024',
        status: 'Completed',
        product: 'product1',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '27.05.2024',
        status: 'Completed',
        product: 'product2',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '30.05.2024',
        status: 'Completed',
        product: 'product3',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '15.05.2024',
        status: 'Cancelled',
        product: 'product4',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '21.05.2024',
        status: 'Ongoing',
        product: 'product5',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      // height: 500,
      child: Scaffold(
        appBar: TabBar(controller: tabController, tabs: const [
          Tab(text: 'Scheduled'),
          Tab(text: 'Ongoing'),
          Tab(text: 'Completed'),
          Tab(text: 'Cancelled'),
        ]),
        body: TabBarView(
          controller: tabController,
          children: [
            contractListCardTrail('Scheduled', const Color(0xff3398F6)),
            contractListCardTrail('Ongoing', const Color(0xff3EE094)),
            contractListCardTrail('Completed', const Color(0xffD95AF3)),
            contractListCardTrail('Cancelled', const Color(0xffFA4A42)),
          ],
        ),
      ),
    );
  }

  Card contractListCardTrail(String status, Color color) {
    final filteredContracts =
        contracts.where((c) => c.status == status).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('date',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('status',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('product',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('from',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('to',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    width: 0,
                  )
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: filteredContracts.length,
                itemBuilder: (context, index) {
                  return ContractItem(
                    contract: filteredContracts[index],
                    color: color,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Contract {
  final String date;
  final String status;
  final String product;
  final String from;
  final String to;

  Contract(
      {required this.date,
      required this.status,
      required this.product,
      required this.from,
      required this.to});
}

class ContractItem extends StatelessWidget {
  final Contract contract;
  final Color color;

  const ContractItem({super.key, required this.contract, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const SizedBox(
          //   width: 5,
          // ),
          Text(contract.date, style: const TextStyle(fontSize: 14)),
          Text(contract.status, style: TextStyle(fontSize: 14, color: color)),
          // const SizedBox(
          //   width: 10,
          // ),
          Text(contract.product, style: const TextStyle(fontSize: 14)),
          // const SizedBox(
          //   width: 30,
          // ),
          Text(contract.from, style: const TextStyle(fontSize: 14)),
          // const Text("To"),
          Text(contract.to, style: const TextStyle(fontSize: 14)),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(contract.from, style: const TextStyle(fontSize: 14)),
          //     const Text("To"),
          //     Text(contract.to, style: const TextStyle(fontSize: 14)),
          //   ],
          // )
        ],
      ),
    );
  }
}
