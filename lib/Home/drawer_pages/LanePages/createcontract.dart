import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supplink/Backend/firebase/allUserDetails.dart';
import 'package:supplink/Backend/firebase/createContractFirebaseservice.dart';
import 'package:supplink/Backend/firebase/userDeatilsmaintain.dart';
// import 'package:supplink/Backend/firebase/users.dart';
import 'package:supplink/Home/drawer_pages/LanePages/colloborationview.dart';

class CreateColloboration extends StatefulWidget {
  static const String routeName = '/EX_IM';

  CreateColloboration({Key? key}) : super(key: key);

  @override
  _CreateColloborationState createState() => _CreateColloborationState();
}

class _CreateColloborationState extends State<CreateColloboration> {
  int people = 1;
  TextEditingController nameController = TextEditingController();
  final ContractFirebaseService _firebaseService = ContractFirebaseService();
  List<Map<String, dynamic>> _allUsers = [];
  List<String> _locations = [];
  List<String> _domains = [];
  List<String> _users = [];

  // ignore: non_constant_identifier_names
  List<String> _auth_ids = [];

  String itemSelecteddomain = '';
  String itemSelectedVillage = '';
  String itemSelectedMember = '';

  List<String> domainList = ['rg', 'rt'];

  List<List<String>> MemberSelectedOpt = [];
  List<UserDetails> userDetailsPopview = [];
  List toBeCreatedContractingPeoples = [];
  late UserDetailsTable udt;

  bool infoWindowVisible = false;
  late UserDetails currentUserDetailsDisplay;

  @override
  void initState() {
    super.initState();
    udt = UserDetailsTable();
    _getAllUsers();
  }

  Future<void> _getAllUsers() async {
    Map<String, dynamic> usersMap = await _firebaseService.getAllUsers();
    setState(() {
      _allUsers = usersMap['AllUsers'];
      _locations = usersMap['Village'];
      _users = usersMap['User_ids'];
      _domains = usersMap['Domain'];
    });
  }

  Future<void> _search() async {
    print('yes it came');
    if (itemSelecteddomain != '' && itemSelectedVillage != '') {
      await _searchByDomainAndVillage(itemSelecteddomain, itemSelectedVillage);
    } else if (itemSelecteddomain != '') {
      await _searchByDomain(itemSelecteddomain);
    } else if (itemSelectedVillage != '') {
      await _searchByVillage(itemSelectedVillage);
    } else {
      setState(() {
        _locations = [];
        _domains = [];
      });
    }
    print('dfdgu');
    print(_locations);
  }

  Future<void> _searchByDomain(String domain) async {
    Map<String, dynamic> result =
        await _firebaseService.getUsersByDomain(_allUsers, domain);
    List<Map<String, dynamic>> filteredUsers = result['users'];
    List<String> locations = result['locations'];

    setState(() {
      _locations = locations;
      _users = result['User_ids'];
      _auth_ids =
          filteredUsers.map((user) => user['Auth_id'].toString()).toList();
    });
  }

  Future<void> _searchByVillage(String village) async {
    Map<String, dynamic> result =
        await _firebaseService.getUsersByVillage(_allUsers, village);
    List<Map<String, dynamic>> filteredUsers = result['users'];
    List<String> domains = result['domains'];
    setState(() {
      _domains = domains;
      _users = result['User_ids'];
      _auth_ids =
          filteredUsers.map((user) => user['Auth_id'].toString()).toList();
    });
  }

  Future<void> _searchByDomainAndVillage(String domain, String village) async {
    Map<String, dynamic> mapUsers = await _firebaseService
        .getUsersByDomainAndVillage(_allUsers, domain, village);
    List<Map<String, dynamic>> filteredUsers = mapUsers['users'];

    setState(() {
      _users = mapUsers['User_ids'];
      _auth_ids =
          filteredUsers.map((user) => user['Auth_id'].toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Create Contract'),
          ),
          body: Scaffold(
            appBar: TabBar(
              labelColor: Colors.black,
              tabAlignment: TabAlignment.center,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              tabs: [
                Tab(text: 'Create colloboration view'),
                Tab(text: 'Create Manual'),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: screenHeight,
                width: screenWidth,
                child: Card(
                  elevation: 3,
                  child: TabBarView(
                    children: [
                      Center(child: ColloborativeCreation()),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // Display TextField for each string in newStrings list
                          Container(
                            width: double.infinity,
                            // color: Colors.amber,
                            height:
                                550, //400*(newStrings.length as double) > 500 ? 500 : 50*(newStrings.length as double),
                            child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 10,
                                    ),
                                itemCount: people,
                                itemBuilder: (BuildContext context, int index) {
                                  return setupAlertDialoadContainer(index);
                                }),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                // newStrings.add(''); // Add an empty string
                                people++;
                                String Auth_id = _auth_ids[
                                    _users.indexOf(itemSelectedMember)];
                                toBeCreatedContractingPeoples.add(Auth_id);
                                MemberSelectedOpt.add([
                                  itemSelecteddomain,
                                  itemSelectedVillage,
                                  itemSelectedMember
                                ]);
                                userDetailsPopview
                                    .add(currentUserDetailsDisplay);

                                print(itemSelecteddomain);
                                print(itemSelectedVillage);
                                print(itemSelectedMember);
                                print(Auth_id);

                                itemSelectedMember = '';
                                itemSelectedVillage = '';
                                itemSelecteddomain = '';
                                infoWindowVisible = false;
                              });
                            },
                            child: Text('Add More'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      infoWindowVisible = false;
                                      String Auth_id = _auth_ids[
                                          _users.indexOf(itemSelectedMember)];
                                      toBeCreatedContractingPeoples
                                          .add(Auth_id);
                                      MemberSelectedOpt.add([
                                        itemSelecteddomain,
                                        itemSelectedVillage,
                                        itemSelectedMember
                                      ]);
                                      userDetailsPopview
                                          .add(currentUserDetailsDisplay);
                                      // print(itemSelecteddomain);
                                      // print(itemSelectedVillage);
                                      // print(itemSelectedMember);
                                      // print(Auth_id);
                                      // print('printing all members');
                                      print(toBeCreatedContractingPeoples);
                                      _firebaseService.createNewContract(
                                          toBeCreatedContractingPeoples);
                                    });
                                  },
                                  child: Text('create'))
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<UserDetails> SelectedMemberDetails(String Auth_id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentReference =
        firestore.collection('AllUsers').doc(Auth_id);
    DocumentSnapshot snapshot = await documentReference.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data.forEach((key, value) {
      print('$key: $value');
    });
    CollectionReference allUsersCollection =
        FirebaseFirestore.instance.collection('AllUsers');
    CollectionReference userProfileCollection =
        allUsersCollection.doc(Auth_id).collection('Profile');
    String profile = '';
    QuerySnapshot userProfileSnapshot = await userProfileCollection.get();
    if (userProfileSnapshot.docs.isNotEmpty) {
      final urlData = userProfileSnapshot.docs.first.data();
      if (urlData != null) {
        final url = urlData as Map<String, dynamic>;
        profile = url['Profileurl'] as String? ?? '';
        // print(profile);
      } else {
        print('no profile ');
        profile = '';
      }
    }
    UserDetails ud = UserDetails(
        authId: data['Auth_id'],
        name: data['Name'],
        domain: data['Domain'],
        location: data['Location'],
        phoneno: data['Phone'].toString(),
        address: data['Village'],
        profile: profile);
    return ud;
  }

  void PeopleDropDownOnChange(String value) async {
    // String Auth_id =_auth_ids[_users.indexOf(value.toString())];
    // UserDetails u = await SelectedMemberDetails(Auth_id);
    setState(() {
      itemSelectedMember = value.toString();
    });
  }

  Widget setupAlertDialoadContainer(int i) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          children: [
            Container(
              // width: 1000,
              // color: Colors.amber,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    child: Text('${i + 1}.'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 300,
                    // height: 40,
                    child: DropdownSearch<String>(
                      items: _domains,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        fit: FlexFit.loose,
                      ),
                      dropdownButtonProps: DropdownButtonProps(
                        color: Colors.blue,
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        textAlignVertical: TextAlignVertical.center,
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Domain",
                          hintText: "Domain in menu mode",
                          border: OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(50),
                              ),
                        ),
                      ),
                      onChanged: (value) async {
                        setState(() {
                          itemSelecteddomain = value.toString();
                          itemSelectedVillage = '';
                          _search();
                        });
                      },
                      selectedItem: MemberSelectedOpt.length > i
                          ? MemberSelectedOpt[i][0]
                          : itemSelecteddomain,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Search Filter : '),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 300,
                                // height: 40,
                                // color: Colors.blue,
                                child: DropdownSearch<String>(
                                  items: _locations,
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                  ),
                                  dropdownButtonProps: DropdownButtonProps(
                                    color: Colors.blue,
                                  ),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    textAlignVertical: TextAlignVertical.center,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Location",
                                      hintText: "Domain in menu mode",
                                      border: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(50),
                                          ),
                                    ),
                                  ),
                                  onChanged: (value) async {
                                    setState(() {
                                      itemSelectedVillage = value.toString();
                                      _search();
                                    });
                                  },
                                  selectedItem: MemberSelectedOpt.length > i
                                      ? MemberSelectedOpt[i][1]
                                      : itemSelectedVillage,
                                ),
                              ),
                              Container(
                                width: 300,
                                // height: 40,
                                child: DropdownSearch<String>(
                                  items: domainList,
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                  ),
                                  dropdownButtonProps: DropdownButtonProps(
                                    color: Colors.blue,
                                  ),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    textAlignVertical: TextAlignVertical.center,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Date of Connection",
                                      hintText: "Domain in menu mode",
                                      border: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(50),
                                          ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      itemSelecteddomain = value.toString();
                                    });
                                  },
                                  selectedItem: itemSelecteddomain,
                                ),
                              ),
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Select Memeber :                          '),
                            Container(
                              width: 300,
                              // height: 40,
                              child: DropdownSearch<String>(
                                items: _users,
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  fit: FlexFit.loose,
                                ),
                                dropdownButtonProps: DropdownButtonProps(
                                  color: Colors.blue,
                                ),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  textAlignVertical: TextAlignVertical.center,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "People",
                                    hintText: "Domain in menu mode",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                onChanged: (value) async {
                                  String Auth_id = _auth_ids[
                                      _users.indexOf(value.toString())];
                                  UserDetails ud =
                                      await SelectedMemberDetails(Auth_id);
                                  setState(() {
                                    currentUserDetailsDisplay = ud;
                                    infoWindowVisible = true;
                                    itemSelectedMember = value.toString();
                                  });
                                },
                                selectedItem: MemberSelectedOpt.length > i
                                    ? MemberSelectedOpt[i][2]
                                    : itemSelectedMember,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        // color: Colors.pink,
                        width: 300,
                        height: infoWindowVisible == true ||
                                userDetailsPopview.length > i
                            ? 280
                            : 0,
                        child: userDetailsPopview.length > i
                            ? popView(userDetailsPopview[i])
                            : infoWindowVisible == true
                                ? popView(currentUserDetailsDisplay)
                                : Container()),
                  )
                ],
              ),
            ),

            // Expanded(child: Container(color: Colors.green,)),

            SizedBox(
              height: 10,
            ),
            Divider()
          ],
        ),
      ),
    );
  }

  Widget popView(UserDetails selectedUser) {
    return Container(
      height: 320,
      width: 300,
      child: AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                selectedUser.profile.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(selectedUser.profile),
                        radius: 25,
                      )
                    : Icon(
                        Icons.account_circle_sharp,
                        size: 50,
                      ),
              ],
            ),

            // Text('Hello'),
            Text("Name: ${selectedUser.name}"),
            Text("Domain: ${selectedUser.domain}"),
            Text("Phone:${selectedUser.phoneno}"),
            Text("Address:${selectedUser.address}")
            // Replace this with your custom pop-up content
            // Add any other widgets you want in the pop-up
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                infoWindowVisible = false;
              });
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
