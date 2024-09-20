import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supplink/Backend/firebase/createContractFirebaseservice.dart';
import 'package:supplink/Home/drawer_pages/LanePages/contractViews.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:supplink/Home/drawer_pages/LanePages/createcontract.dart';

class LaneWorks extends StatefulWidget {
  const LaneWorks({super.key});

  @override
  State<LaneWorks> createState() => _LaneWorksState();
}

class _LaneWorksState extends State<LaneWorks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('LaneWorks'),
          automaticallyImplyLeading: false,
          // leadingWidth: 45,
        ),
        body: const SingleChildScrollView(
            child: Column(
          children: [LaneListView(), LaneListView()],
        )));
  }
}

class LaneSerachBox extends StatefulWidget {
  const LaneSerachBox({super.key});

  @override
  State<LaneSerachBox> createState() => _LaneSerachBoxState();
}

class _LaneSerachBoxState extends State<LaneSerachBox> {
  List<String> countriesList = [
    'Pakistan',
    'Afghanistan',
    'America',
    'China',
    'Indonesia'
  ];
  String itemSelected = '';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700,
      child: DropdownSearch<String>(
        items: countriesList,
        popupProps: const PopupProps.menu(
          showSearchBox: true,
        ),
        dropdownButtonProps: const DropdownButtonProps(
          color: Colors.blue,
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          textAlignVertical: TextAlignVertical.center,
          dropdownSearchDecoration: InputDecoration(
              labelText: "Search",
              hintText: "country in menu mode",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              )),
        ),
        onChanged: (value) {
          setState(() {
            itemSelected = value.toString();
          });
        },
        selectedItem: itemSelected,
      ),
    );
  }
}

class LaneListView extends StatefulWidget {
  const LaneListView({super.key});

  @override
  State<LaneListView> createState() => _LaneListViewState();
}

class _LaneListViewState extends State<LaneListView> {
  @override
  Widget build(BuildContext context) {
    // var screenSize = MediaQuery.of(context).size;
    // var width = screenSize.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Divider(),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              const LaneSerachBox(),
              const Spacer(),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateColloboration()),
                    );
                  },
                  child: const Text('Create Contract'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 300,
          child: Container(
              color: const Color.fromARGB(221, 223, 225, 242),
              child: const ContractListView()),
        ),
        const Divider(),
      ],
    );
  }
}

class ContractListView extends StatefulWidget {
  const ContractListView({super.key});

  @override
  State<ContractListView> createState() => _ContractListViewState();
}

class _ContractListViewState extends State<ContractListView> {
  late Future<List<Map<String, dynamic>>> contractInfo;

  @override
  void initState() {
    ContractFirebaseService cfs = ContractFirebaseService();
    // String uid = FirebaseAuth.instance.currentUser!.uid;
    contractInfo = cfs.getUserAllContractsInfo('7o2CGFJGgAf4XZjBXWHBkmGjyXD2');

    super.initState();
  }

  Widget _buildShimmerEffect() {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  width: 5,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: Container(
                    width: 200,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.white,
            child: Container(
              width: 350,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: contractInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              // itemCount: contractInfo.length,
              itemBuilder: (BuildContext context, int index) =>
                  SizedBox(width: 400, child: _buildShimmerEffect()),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No contract information available.'),
            );
          } else {
            final contractInfo = snapshot.data!;
            return ListView.builder(
              // physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: contractInfo.length,
              itemBuilder: (BuildContext context, int index) => SizedBox(
                width: 400,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ContractView(contractInfo[index]),
                      ),
                    );
                  },
                  child: Card(
                    child: MemberCompanyDetails(contractInfo[index]),
                  ),
                ),
              ),
            );
          }
        });
  }
}

class MemberCompanyDetails extends StatelessWidget {
  final Map<String, dynamic> contractInfo;

  const MemberCompanyDetails(this.contractInfo, {super.key});

  int randomNumbers() {
    Random random = Random();
    int randomNumber1 = random.nextInt(10) + 1;
    return randomNumber1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          leading: FlutterLogo(),
          title: Text('Contract Info'),
        ),
        const Divider(),
        SizedBox(
          height: 155,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 155,
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text(
                                'On-Going Contracts : ${contractInfo['onGoingContracts']}'),
                          ),
                          ListTile(
                            title: Text(
                                'Completed Contracts : ${contractInfo['completedContracts']}'),
                          ),
                          ListTile(
                            title: Text(
                                'Total Contracts : ${contractInfo['totalContracts']}'),
                          ),
                        ],
                      ),
                      // color: Colors.amber,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 150,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    animationDuration: Duration(milliseconds: 6000),
                    dataMap: {
                      "Flutter": 30,
                      "React": 30,
                      "Xamarin": 45,
                    },
                    legendOptions: LegendOptions(showLegends: false),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValuesOutside: false,
                    ),
                    // other properties...
                  ),
                ),
              ), //TODO Correct the alignment of pie chart
            ],
          ),
        ),
        Expanded(
          child: Container(
            // color:Colors.orange.shade50,
            child: Column(
              children: [
                Card(
                  child: LinearPercentIndicator(
                    animation: true,
                    lineHeight: 20.0,
                    animationDuration: 6000,
                    percent: 0.9,
                    center: Text(
                        "Lane Success Rate - ${(randomNumbers() / 10) * 100}%"),
                    // linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.purple.shade300,
                  ),
                ),
                const SizedBox(height: 10),
                LinearPercentIndicator(
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 6000,
                  percent: 0.9,
                  center: Text(
                      "Your Contribution - ${(randomNumbers() / 10) * 100}%"),
                  // linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.red.shade300,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}




// class ContractView extends StatefulWidget {
//   const ContractView({super.key});

//   @override
//   State<ContractView> createState() => _ContractViewState();
// }

// class _ContractViewState extends State<ContractView> {
//   @override
//   Widget build(BuildContext context) {
//     return Column();
//   }
// }

