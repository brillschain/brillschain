import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supplink/Home/drawer_pages/LanePages/createcontract.dart';
// import 'package:path/path.dart';
import 'package:supplink/Routes/routes.dart';
import 'package:supplink/Backend/firebase/createContractFirebaseservice.dart';
// import 'package:supplink/Home/desktop_Body.dart';
import 'package:supplink/Home/drawer_pages/LanePages/laneview.dart';

class ContractView extends StatefulWidget {
  final Map<String, dynamic> contractInfo;
  const ContractView(this.contractInfo, {super.key});
  @override
  State<ContractView> createState() => _ContractViewState();
}

class _ContractViewState extends State<ContractView> {
  // DesktopBodyState desk = DesktopBodyState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 1000,
        title: const Text('Contracts'),
        automaticallyImplyLeading: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                  // style: ButtonStyle(
                  // ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateColloboration()),
                    );
                  },
                  child: const Text('Create New')),
            ),
          )
        ],
      ),
      drawer: const Drawer(),
      body: LaneAndContractAndDashView(widget.contractInfo),
    );
  }
}

class LaneAndContractAndDashView extends StatefulWidget {
  final Map<String, dynamic> contractInfo;
  const LaneAndContractAndDashView(this.contractInfo, {super.key});

  @override
  State<LaneAndContractAndDashView> createState() =>
      _LaneAndContractAndDashViewState();
}

class _LaneAndContractAndDashViewState
    extends State<LaneAndContractAndDashView> {
  late List<Map<String, dynamic>> LaneDetails = [];
  late ContractFirebaseService cfs;
  late String currentUserUid;

  @override
  void initState() {
    super.initState();
    cfs = ContractFirebaseService();
    currentUserUid = '7o2CGFJGgAf4XZjBXWHBkmGjyXD2';
    _update(cfs, currentUserUid);
  }

  void _update(ContractFirebaseService cfs, String currentUserUid) async {
    List<Map<String, dynamic>> m =
        await cfs.getLaneDetailsOfAUser(currentUserUid, widget.contractInfo);
    setState(() {
      LaneDetails = m;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (LaneDetails.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 1000,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: LaneDetails.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> laneDetail =
                                  LaneDetails[index];
                              String companyName =
                                  'Operation : ${laneDetail['operation']}';
                              String LaneID =
                                  'Created_at : ${laneDetail['created_at'].toDate()}';
                              String members =
                                  'No.Of.Chain Members : ${widget.contractInfo['my_list'].length}';
                              String onGoing = 'OnGoing Chain :';
                              return SizedBox(
                                  height: 170,
                                  child: Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                companyName,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 100,
                                                      // width: 200,
                                                      child: ListView(
                                                        children: [
                                                          ListTile(
                                                            title: Text(LaneID),
                                                          ),
                                                          ListTile(
                                                            title:
                                                                Text(members),
                                                          ),
                                                          ListTile(
                                                            title:
                                                                Text(onGoing),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 100,
                                                      // width: 200,
                                                      child: ListView(
                                                        children: const [
                                                          ListTile(
                                                            leading: Icon(
                                                                Icons.check),
                                                            title: Text(
                                                                'On-Going Contract'),
                                                          ),
                                                          ListTile(
                                                            leading: Icon(
                                                                Icons.archive),
                                                            title: Text(
                                                                'Completed Contract'),
                                                          ),
                                                          ListTile(
                                                            leading: Icon(
                                                                Icons.check),
                                                            title: Text(
                                                                'Total Contracts'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                margin: const EdgeInsets.only(
                                                    top: 35, right: 90),
                                                height: 40,
                                                width: 120,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      // Navigator.of(context)
                                                      //     .pushNamed(AppRoutes
                                                      //         .LaneViewRoute);
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) => LaneView(
                                                              widget.contractInfo[
                                                                  'ContractServerid'],
                                                              laneDetail[
                                                                  'docName']),
                                                          settings:
                                                              const RouteSettings(
                                                                  name: AppRoutes
                                                                      .laneViewRoute), // Provide a route name here
                                                        ),
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 10,
                                                      shadowColor: Colors.blue,
                                                    ),
                                                    child: const Text(
                                                      "View lane",
                                                    )),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
