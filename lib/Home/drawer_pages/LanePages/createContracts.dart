// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:supplink/Backend/firebase/firestore.dart';


// class CreateColloboration extends StatefulWidget {
//   static const String routeName = '/EX_IM';

//   CreateColloboration({Key? key}) : super(key: key);

//   @override
//   _CreateColloborationState createState() => _CreateColloborationState();
// }

// class _CreateColloborationState extends State<CreateColloboration> {
//   // List<String> domainList = ['farmers', 'manufacturers', 'distributors', 'wholesalers', 'retailers'];
//   int people=1;
//   TextEditingController nameController = TextEditingController();


//   List<String> Location = ['Bhimavaram', 'vizag', 'Rajamundry'];
//   String itemSelectedlocation = '';

  


//   List<String> domainList = ['Farmer', 'Manufacture', 'Retailer', 'Supplier'];
//   String itemSelecteddomain = '';
//   String itemSelectedMember = '';



//   late List<MapEntry<String, dynamic>> mapEntryList = [];
//   List<String> DomainSpecificUsers = [];


  

//   Firestore fs = Firestore();

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     double listViewWidth = (screenWidth/5);

//     return Scaffold(
//       body: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text('Create Contract'),
//           ),
//           body: Scaffold(
//             appBar: TabBar(
//               labelColor: Colors.black,
//               tabAlignment: TabAlignment.center,
//               indicatorSize: TabBarIndicatorSize.tab,
//               labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
//               tabs: [
//                 Tab(text: 'Create colloboration view'),
//                 Tab(text: 'Create Manual'),
//               ],
//             ),
//             body: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Card(
//                 elevation: 3,
//                 child: TabBarView(
//                   children: [
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: SizedBox(
//                         width: screenWidth,
//                         child: ListView.separated(
//                           itemCount: domainList.length,
//                           scrollDirection: Axis.horizontal,
//                           itemBuilder: (context, index) {
//                             return Container(
//                               width: listViewWidth,
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     height: 100,
//                                     width: listViewWidth,
//                                     color: Colors.green,
//                                     child: Center(
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             Text(domainList[index]),
//                                             IconButton(
//                                               onPressed: () {},
//                                               icon: Icon(Icons.more_horiz),
//                                             ),
//                                             ElevatedButton(
//                                               onPressed: () {
//                                                 setState(() {
//                                                   domainList.insert(index + 1, 'New Designation');
//                                                 });
//                                               },
//                                               child: Text('Add'),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Container(
//                                     // color: Colors.black,
//                                     height: 570,
//                                     child: ListView.separated(
//                                       itemCount: 10,
//                                       scrollDirection: Axis.vertical,
//                                       itemBuilder: (context, index) {
//                                         if(index<9)
//                                           return Container(
//                                             height: 100,
//                                             color: Color.fromARGB(255, 220, 218, 218),
//                                           );
//                                         else{
//                                           return Container(
//                                           height: 100,
//                                           color: Color.fromARGB(255, 220, 218, 218),
//                                           child: Row(
//                                             children: [
//                                               IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                                              
//                                             ],
//                                           ),
//                                         );
//                                         }
      
//                                       },
//                                       separatorBuilder: (context, index) {
//                                         return SizedBox(height: 10);
//                                       },
//                                     ),
//                                   ),
      
//                                 ],
//                               ),
//                             );
//                           },
//                           separatorBuilder: (context, index) {
//                             return SizedBox(width: 10);
//                           },
//                         ),
//                       ),
//                     ),
//                                     Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: <Widget>[
//                                         // Display TextField for each string in newStrings list
//                                         Container(
//                                           width: 1100,
//                                           height: 550,//400*(newStrings.length as double) > 500 ? 500 : 50*(newStrings.length as double),
//                                           child: ListView.separated(
//                                                     physics: BouncingScrollPhysics(),
//                                                     shrinkWrap: true,
//                                                     separatorBuilder: (context, index) => SizedBox(
//                                                       height: 10,
//                                                     ),

//                                                     itemCount: people,
//                                                     itemBuilder: (BuildContext context, int index) {
//                                                       return setupAlertDialoadContainer(index);
//                                                     }),
//                                         ),
//                                         TextButton(
//                                           onPressed: () {
//                                             setState(() {
//                                               // newStrings.add(''); // Add an empty string
//                                               people++;
//                                             });
//                                           },
//                                           child: Text('Add More'),
//                                         ),
//                                         SizedBox(height: 10,),
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             ElevatedButton(onPressed: (){}, child: Text('create'))
//                                           ],
//                                         )

                                        
//                                       ],
//                                     ),                  ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget setupAlertDialoadContainer(int i) {
//     return Padding(
//       padding: const EdgeInsets.only(top :5.0),
//       child: Column(
//         children: [
//           Center(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       child: Text('${i+1}.'),
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Container(
//                       width: 300,
//                       // height: 40,
//                       child: DropdownSearch<String>(
//                               items: domainList,
//                               popupProps: PopupProps.menu(
//                                 showSearchBox: true,
//                                 fit:   FlexFit.loose,
//                               ),
//                               dropdownButtonProps: DropdownButtonProps(
//                                 color: Colors.blue,
//                               ),
//                               dropdownDecoratorProps: DropDownDecoratorProps(
                                
//                                 textAlignVertical: TextAlignVertical.center,
//                                 dropdownSearchDecoration: InputDecoration(
//                                   labelText: "Domain",
//                                   hintText: "Domain in menu mode",
//                                   border: OutlineInputBorder(
//                                       // borderRadius: BorderRadius.circular(50),
//                                       ),
//                                 ),
//                               ),
//                               onChanged: (value) {
//                                 setState(() {
                    
//                                   itemSelecteddomain = value.toString();
//                                   update(itemSelecteddomain);
//                                 });
//                               },
//                               selectedItem: itemSelecteddomain,
//                             ),
//                     ),
//                     SizedBox(
//                       width: 40,
//                     ),
//                     Expanded(
//                       child: Container( 
//                         // color: Colors.amber,
//                         // height: 200,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
                            
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Search Filter : '),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Container(
//                                   width: 300,
//                                   // height: 40,
//                                   child: DropdownSearch<String>(
//                                           items: Location,
//                                           popupProps: PopupProps.menu(
//                                             showSearchBox: true,
//                                             fit:   FlexFit.loose,
//                                           ),
//                                           dropdownButtonProps: DropdownButtonProps(
//                                             color: Colors.blue,
//                                           ),
//                                           dropdownDecoratorProps: DropDownDecoratorProps(
                                            
//                                             textAlignVertical: TextAlignVertical.center,
//                                             dropdownSearchDecoration: InputDecoration(
//                                               labelText: "Location",
//                                               hintText: "Domain in menu mode",
//                                               border: OutlineInputBorder(
//                                                   // borderRadius: BorderRadius.circular(50),
//                                                   ),
//                                             ),
//                                           ),
//                                           onChanged: (value) {
//                                             setState(() {
//                                               itemSelectedlocation = value.toString();
//                                             });
//                                           },
//                                           selectedItem: itemSelectedlocation,
//                                         ),
//                                 ),
//                                 Container(
//                                   width: 300,
//                                   // height: 40,
//                                   child: DropdownSearch<String>(
//                                           items: domainList,
//                                           popupProps: PopupProps.menu(
//                                             showSearchBox: true,
//                                             fit:   FlexFit.loose,
//                                           ),
//                                           dropdownButtonProps: DropdownButtonProps(
//                                             color: Colors.blue,
//                                           ),
//                                           dropdownDecoratorProps: DropDownDecoratorProps(
                                            
//                                             textAlignVertical: TextAlignVertical.center,
//                                             dropdownSearchDecoration: InputDecoration(
//                                               labelText: "Date of Connection",
//                                               hintText: "Domain in menu mode",
//                                               border: OutlineInputBorder(
//                                                   // borderRadius: BorderRadius.circular(50),
//                                                   ),
//                                             ),
//                                           ),
//                                           onChanged: (value) {
//                                             setState(() {
//                                               itemSelecteddomain = value.toString();
//                                             });
//                                           },
//                                           selectedItem: itemSelecteddomain,
//                                         ),
//                                 ),
//                             ]),
          
//                             SizedBox( height: 10,),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               // mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text('Select Memeber :                          '),
//                                   Container(
//                                   width: 300,
//                                   // height: 40,
//                                   child: DropdownSearch<String>(
//                                           items: DomainSpecificUsers,
//                                           popupProps: PopupProps.menu(
//                                             showSearchBox: true,
//                                             fit:   FlexFit.loose,
//                                           ),
//                                           dropdownButtonProps: DropdownButtonProps(
//                                             color: Colors.blue,
//                                           ),
//                                           dropdownDecoratorProps: DropDownDecoratorProps(
                                            
//                                             textAlignVertical: TextAlignVertical.center,
//                                             dropdownSearchDecoration: InputDecoration(
//                                               labelText: "People",
//                                               hintText: "Domain in menu mode",
//                                               border: OutlineInputBorder(
//                                                   // borderRadius: BorderRadius.circular(50),
//                                                   ),
//                                             ),
//                                           ),
//                                           onChanged: (value) {
//                                             setState(() {
//                                               itemSelectedMember = value.toString();
//                                             });
//                                           },
//                                           selectedItem: itemSelectedMember,
//                                         ),
//                                 ),
//                               ],
//                             ),
                                                    
//                           ],
//                         ),
                        
//                       ),
//                     ),
                   
//                   ],
//                 ),
//               ),
//                SizedBox(height: 10,),
//               Divider()
//         ],
//       ),
//     );
      
//   }

//   void update(String itemselected){

//     setState(() async {
//       mapEntryList.clear();
//       DomainSpecificUsers.clear();
//       Map<String, dynamic> m = await fs.getAllUsersInDomains(itemselected);
//       mapEntryList = m.entries.toList();

//       for (var entry in mapEntryList) {
//         String key = entry.key;
//         dynamic value = entry.value;
//         DomainSpecificUsers.add(value);
//       }

//     });
//   }

// }
