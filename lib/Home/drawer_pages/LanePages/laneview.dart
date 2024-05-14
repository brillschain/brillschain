import 'package:flutter/material.dart';
import 'package:supplink/Backend/firebase/createContractFirebaseservice.dart';
import 'package:supplink/Home/drawer_pages/LanePages/LaneView/tradeView.dart';

class LaneView extends StatefulWidget {
  final String contractInfoCollectionName;
  final String laneDetaildocumentName;

  const LaneView(this.contractInfoCollectionName, this.laneDetaildocumentName, {Key? key})
      : super(key: key);

  @override
  State<LaneView> createState() => _LaneViewState();
}

class _LaneViewState extends State<LaneView> {
  late List<Map<String, dynamic>> listOfImportAndExportDetailsOfAllPeopleInThelane = [];
  late ContractFirebaseService cfs;
  late List<String> tabsList = [];

  @override
  void initState() {
    super.initState();
    _update();
  }

void _update() async {
  cfs = ContractFirebaseService();
  final l = await cfs.getAllUserTableDetailsInTheLane(widget.laneDetaildocumentName, widget.contractInfoCollectionName);
  setState(() {
    listOfImportAndExportDetailsOfAllPeopleInThelane = l;
    tabsList = listOfImportAndExportDetailsOfAllPeopleInThelane.map((data) {
      String tex = data['Domain'] ?? ''; // If Domain is null, use an empty string
      return tex.toString(); // Convert to string explicitly
    }).toList();
  });
}


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lane Works Data'),
        ),
        body: Scaffold(
          appBar: TabBar(
            labelColor: Colors.black,
            tabAlignment: TabAlignment.center,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            tabs: [
              Tab(text: 'Supply Chain View'),
              Tab(text: 'Product View'),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 3,
              child: TabBarView(
                children: [
                  DefaultTabController(
                    length: tabsList.length, // Update length here
                    child: Scaffold(
                      appBar: TabBar(
                        labelColor: Colors.black,
                        indicatorColor: Colors.amber,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: tabsList.isEmpty ? [const Tab(text: 'Loading...')] : tabsList.map((tabText) => Tab(text: tabText)).toList(), // Updated here
                      ),
                      body: TabBarView(
                        children: List.generate(
                          tabsList.length,
                          (index) => TradeView(
                            listOfImportAndExportDetailsOfAllPeopleInThelane[index]['ContractServerId'], 
                            listOfImportAndExportDetailsOfAllPeopleInThelane[index]['userAuthId'],
                            listOfImportAndExportDetailsOfAllPeopleInThelane[index]['LaneId']
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Center(
                    child: Text('Product view'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}






//contractServerId, userId, Operation or Lane number,