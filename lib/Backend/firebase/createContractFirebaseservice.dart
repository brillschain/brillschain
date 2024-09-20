// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:supplink/Backend/firebase/firestore.dart';

class ContractFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getAllUsers() async {
    Map<String, dynamic> map = {};
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('AllUsers').get();

      List<Map<String, dynamic>> allusers = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList(); // List<Map<String, dynamic>>

      // map['userNames'] = allusers.map((user) => user['Name'].toString()).toList();
      map['User_ids'] =
          allusers.map((user) => user['User_id'].toString()).toList();
      map['Village'] =
          allusers.map((user) => user['Village'].toString()).toList();
      map['Domain'] =
          allusers.map((user) => user['Domain'].toString()).toList();
      map['AllUsers'] = allusers;

      return map;
    } catch (e) {
      print('Error fetching all users: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getUsersByDomain(
      List<Map<String, dynamic>> allUsers, String domain) async {
    try {
      List<Map<String, dynamic>> filteredUsers =
          allUsers.where((user) => user['Domain'] == domain).toList();

      List<String> locations = filteredUsers
          .map((user) => user['Village'].toString())
          .toSet()
          .toList();
      List<String> userNames =
          filteredUsers.map((user) => user['User_id'].toString()).toList();

      return {
        'users': filteredUsers,
        'locations': locations,
        'User_ids': userNames
      };
    } catch (e) {
      print('Error fetching users by domain: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getUsersByVillage(
      List<Map<String, dynamic>> allUsers, String village) async {
    try {
      List<Map<String, dynamic>> filteredUsers =
          allUsers.where((user) => user['Village'] == village).toList();

      List<String> domains = filteredUsers
          .map((user) => user['Domain'].toString())
          .toSet()
          .toList();
      List<String> userNames =
          filteredUsers.map((user) => user['User_id'].toString()).toList();

      return {
        'users': filteredUsers,
        'domains': domains,
        'User_ids': userNames
      };
    } catch (e) {
      print('Error fetching users by village: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getUsersByName(
      List<Map<String, dynamic>> allUsers, String name) async {
    try {
      List<Map<String, dynamic>> filteredUsers =
          allUsers.where((user) => user['User_id'] == name).toList();
      List<String> userNames =
          filteredUsers.map((user) => user['User_id'].toString()).toList();
      return {'users': filteredUsers, 'User_ids': userNames};
    } catch (e) {
      print('Error fetching users by name: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getUsersByDomainAndVillage(
      List<Map<String, dynamic>> allUsers,
      String domain,
      String village) async {
    try {
      List<Map<String, dynamic>> filteredUsers = allUsers
          .where(
              (user) => user['Domain'] == domain && user['Village'] == village)
          .toList();
      List<String> userNames =
          filteredUsers.map((user) => user['User_id'].toString()).toList();
      return {'users': filteredUsers, 'User_ids': userNames};
    } catch (e) {
      print('Error fetching users by domain and village: $e');
      return {};
    }
  }

  Future<void> createNewContract(
      List tobecreatedcontractauthIds, BuildContext context) async {
    DateTime now = DateTime.now();
    String randomString = generateRandomString(tobecreatedcontractauthIds);
    String documentName = randomString;
    List myList = tobecreatedcontractauthIds;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot existingDoc =
        await firestore.collection('Contracts').doc(documentName).get();
    if (existingDoc.exists) {
      await firestore.collection('Contracts').doc(documentName).update({
        'onGoingContracts': FieldValue.increment(1),
        'totalContracts': FieldValue.increment(1),
      });
    } else {
      await firestore.collection('Contracts').doc(documentName).set({
        'my_list': myList,
        'onGoingContracts': 1,
        'completedContracts': 0,
        'totalContracts': 1
      });
    }
    DocumentReference documentReference =
        firestore.collection('Contracts').doc(documentName);

    for (String element in myList) {
      QuerySnapshot querySnapshot =
          await documentReference.collection(element).get();

      if (querySnapshot.size == 0) {
        await documentReference
            .collection(element)
            .doc('Operations${querySnapshot.size + 1}')
            .set({'created_at': now});
      } else {
        int operationsCount = querySnapshot.size;
        await documentReference
            .collection(element)
            .doc('Operations${operationsCount + 1}')
            .set({'created_at': now});
      }

      DocumentReference userDoc = firestore.collection('AllUsers').doc(element);
      await userDoc
          .collection('myContracts')
          .doc(documentName)
          .set({'created_at': now});
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('contract created')));
  }

  String generateRandomString(List authIdlist) {
    authIdlist.sort();
    String s = '';
    for (int i = 0; i < authIdlist.length; i++) {
      s = s + authIdlist[i];
    }
    return s;
  }

// -----------------------------------------------------------------------------------------------------------------------

  Future<List<String>> getAllUserContracts(String uid) async {
    List<String> contractIds = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('AllUsers')
        .doc(uid)
        .collection('myContracts')
        .get();

    for (var doc in querySnapshot.docs) {
      contractIds.add(doc.id);
    }

    return contractIds;
  }

  Future<Map<String, dynamic>> getTheContractInfo(
      String ContractServerid) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Contracts')
        .doc(ContractServerid)
        .get();

    Map<String, dynamic> contractData =
        documentSnapshot.data() as Map<String, dynamic>;
    contractData['ContractServerid'] = ContractServerid;
    return contractData;

    // ContractsInfo { 'ContractServerId' : "bcwfwbuifbifwifubwufbwfwifwjfhiw",
    //                 'OnGoingContracts' : int,
    //                 'completedContracts : int,
    //                 'my_list' : //List of all member uids who are in the contract.
    //                }
  }

  Future<List<Map<String, dynamic>>> getUserAllContractsInfo(String uid) async {
    List<String> userAllContracts = await getAllUserContracts(uid);
    List<Map<String, dynamic>> userAllContractsInfo = [];
    for (int i = 0; i < userAllContracts.length; i++) {
      userAllContractsInfo.add(await getTheContractInfo(userAllContracts[i]));
    }
    return userAllContractsInfo;
  }

  Future<List<Map<String, dynamic>>> getLaneDetailsOfAUser(
      String uid, Map<String, dynamic> contractDetails) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('Contracts')
        .doc(contractDetails['ContractServerid'])
        .collection(uid)
        .get();
    List<Map<String, dynamic>> documentData = [];
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      docData['operation'] = int.parse(doc.id.substring(doc.id.length - 1));
      docData['docName'] = doc.id;
      documentData.add(docData);
    }
    return documentData;
  }

  Future<List<Map<String, dynamic>>> getAllUserTableDetailsInTheLane(
      String LaneId, String ContractServerId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
        await firestore.collection('Contracts').doc(ContractServerId).get();
    Map<String, dynamic> docData =
        documentSnapshot.data() as Map<String, dynamic>;

    List<String> userAuthIds = [];
    for (int i = 0; i < docData['my_list'].length; i++) {
      userAuthIds.add(docData['my_list'][i] as String);
    }

    List<Map<String, dynamic>>
        listOfImportAndExportDetailsOfAllPeopleInThelane = [];
    for (int i = 0; i < userAuthIds.length; i++) {
      Map<String, dynamic> data = {};
      DocumentSnapshot documentSnapshot =
          await firestore.collection('AllUsers').doc(userAuthIds[i]).get();
      Map<String, dynamic> docData =
          documentSnapshot.data() as Map<String, dynamic>;

      String domainValue =
          docData['Domain'] as String? ?? ''; // Safe cast and null check

      data['Domain'] = domainValue;
      data['userAuthId'] = userAuthIds[i];
      data['ContractServerId'] = ContractServerId;
      data['LaneId'] = LaneId;
      listOfImportAndExportDetailsOfAllPeopleInThelane.add(data);
    }

    return listOfImportAndExportDetailsOfAllPeopleInThelane;
  }

  // Future<List<CollectionReference>> getTableDetailsInTheLane(String LaneId, String ContractServerId, String uid) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   DocumentReference laneDocRef = firestore.collection('Contracts').doc(ContractServerId).collection(uid).doc(LaneId);

  //   CollectionReference importsCollection = laneDocRef.collection('Imports');
  //   CollectionReference exportsCollection = laneDocRef.collection('Exports');

  //   return [importsCollection, importsCollection];
  // }
  // QuerySnapshot importsQuery = await importsCollection.limit(1).get();

  // if (importsQuery.docs.isEmpty) {
  //   await importsCollection.add({
  //     'Date': '',
  //     'Product_id': '',
  //     'Product_Name': '',
  //     'Product_type': '',
  //     'Quantity': 0,
  //     'Price': 0,
  //     'Weight': 0,
  //     'Volume': 0,
  //     'Vendor_lead_time': Timestamp.fromDate(DateTime.now()),
  //     'Customer_lead_time': Timestamp.fromDate(DateTime.now()),
  //   });
  // }

  // CollectionReference exportsCollection = laneDocRef.collection('Exports');
  // QuerySnapshot exportsQuery = await exportsCollection.limit(1).get();

  // if (exportsQuery.docs.isEmpty) {
  //   await exportsCollection.add({
  //     'Date': '',
  //     'Product_id': '',
  //     'Product_Name': '',
  //     'Product_type': '',
  //     'Quantity': 0,
  //     'Price': 0,
  //     'Weight': 0,
  //     'Volume': 0,
  //     'Vendor_lead_time': Timestamp.fromDate(DateTime.now()),
  //     'Customer_lead_time': Timestamp.fromDate(DateTime.now()),
  //   });
  // }

  // QuerySnapshot importsSnapshot = await importsCollection.get();
  // QuerySnapshot exportsSnapshot = await exportsCollection.get();

  // Map<String, dynamic> tableDetails = {
  //   'Imports': [],
  //   'Exports': [],
  // };

  // importsSnapshot.docs.forEach((doc) {
  //   tableDetails['Imports'].add(doc.data());
  // });

  // exportsSnapshot.docs.forEach((doc) {
  //   tableDetails['Exports'].add(doc.data());
  // });

  // return tableDetails;
  // }
}
