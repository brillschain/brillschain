// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirebaseService {
//   late String contractServerId;
//   late String userAuthId;
//   late String laneId;
//   late String tableName;

//   late CollectionReference tableRef;

//   FirebaseService(String contractServerId, String userAuthId, String laneId, String tableName) {
//     this.contractServerId = contractServerId;
//     this.userAuthId = userAuthId;
//     this.laneId = laneId;
//     this.tableName = tableName;

//     this.tableRef = FirebaseFirestore.instance
//         .collection('Contracts')
//         .doc(contractServerId)
//         .collection(userAuthId)
//         .doc(laneId)
//         .collection(tableName);
//   }

//   Future<void> createRecord(Map<String, dynamic> data) async {
//     try {
//       await tableRef.add(data);
//     } catch (e) {
//       print("Error creating record: $e");
//     }
//   }

//   Stream<QuerySnapshot> getRecords() {
//     return tableRef.snapshots();
//   }

//   Future<DocumentSnapshot> getRecordById(String id) async {
//     return await tableRef.doc(id).get();
//   }

//   Future<void> updateRecord(String id, Map<String, dynamic> data) async {
//     try {
//       await tableRef.doc(id).update(data);
//     } catch (e) {
//       print("Error updating record: $e");
//     }
//   }

//   Future<void> deleteRecord(String id) async {
//     try {
//       await tableRef.doc(id).delete();
//     } catch (e) {
//       print("Error deleting record: $e");
//     }
//   }
// }


















































import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  late String contractServerId;
  
  late String userAuthId;
  
  late String laneId;
  
  late String tableName;

  late CollectionReference usersTableRef;

  FirebaseService(String contractServerId, String userAuthId, String laneId, String tableName){
    this.contractServerId = contractServerId;
    this.userAuthId = userAuthId;
    this.laneId = laneId;
    this.tableName = tableName;
    this.usersTableRef = FirebaseFirestore.instance.collection('Contracts').doc(contractServerId).collection(userAuthId).doc(laneId).collection(tableName);
  }

  Future<void> createProduct(Map<String, dynamic> data) async {
    try {
      print('Inside the create-------------------');
      await usersTableRef.add(data);
      var m = usersTableRef.snapshots();
      printStream(m);     
    } catch (e) {
      print("Error creating product: $e");
    }
  }

  void printStream(Stream<QuerySnapshot> stream) {
    stream.listen((QuerySnapshot snapshot) {
      // print('Received a new snapshot:');
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        print('Document ID: ${doc.id}');
        print('Data: ${doc.data()}');
      }
    }, onError: (dynamic error) {
      print('Stream error: $error');
    }, onDone: () {
      print('Stream closed');
    });
  }

  // Read
  Stream<QuerySnapshot> getProducts() {
    
    print('comdsfdsfsd--------------------');
    var m = usersTableRef.snapshots();
    printStream(m);
    
    return m;
  }

  Future<DocumentSnapshot> getProductHavingProductId(String productId) async{
    return await usersTableRef.doc(productId).get();
  }

  // Update
  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      await usersTableRef.doc(id).update(data);
    } catch (e) {
      print("Error updating product: $e");
    }
  }

  // Delete
  Future<void> deleteProduct(String id) async {
    try {
      await usersTableRef.doc(id).delete();
    } catch (e) {
      print("Error deleting product: $e");
    }
  }
}

























































































// class FirebaseService_Suppliers {
//   final CollectionReference importsRef =
//       FirebaseFirestore.instance.collection('Imports');
//   // Create
//   Future<void> createProduct(Map<String, dynamic> data, String uid) async {
//     try {
//       await importsRef.doc('suppliers').collection(uid).add(data);
//     } catch (e) {
//       print("Error creating product: $e");
//     }
//   }

//   // Read
//   Stream<QuerySnapshot> getProducts(String uid) {
//     return importsRef.doc('suppliers').collection(uid).snapshots();
//   }

//   // Update
//   Future<void> updateProduct(
//       String id, Map<String, dynamic> data, String uid) async {
//     try {
//       await importsRef.doc('suppliers').collection(uid).doc(id).update(data);
//     } catch (e) {
//       print("Error updating product: $e");
//     }
//   }

//   // Delete
//   Future<void> deleteProduct(String id, String uid) async {
//     try {
//       await importsRef.doc('suppliers').collection(uid).doc(id).delete();
//     } catch (e) {
//       print("Error deleting product: $e");
//     }
//   }
// }

// class FirebaseService_Manufactures {
//   final CollectionReference importsRef =
//       FirebaseFirestore.instance.collection('Imports');
//   // Create
//   Future<void> createProduct(Map<String, dynamic> data, String uid) async {
//     try {
//       await importsRef.doc('manufacture').collection(uid).add(data);
//     } catch (e) {
//       print("Error creating product: $e");
//     }
//   }

//   // Read
//   Stream<QuerySnapshot> getProducts(String uid) {
//     return importsRef.doc('manufacture').collection(uid).snapshots();
//   }

//   // Update
//   Future<void> updateProduct(
//       String id, Map<String, dynamic> data, String uid) async {
//     try {
//       await importsRef.doc('manufacture').collection(uid).doc(id).update(data);
//     } catch (e) {
//       print("Error updating product: $e");
//     }
//   }

//   // Delete
//   Future<void> deleteProduct(String id, String uid) async {
//     try {
//       await importsRef.doc('manufacture').collection(uid).doc(id).delete();
//     } catch (e) {
//       print("Error deleting product: $e");
//     }
//   }
// }

// class FirebaseService_Retailers {
//   final CollectionReference importsRef =
//       FirebaseFirestore.instance.collection('Imports');
//   // Create
//   Future<void> createProduct(Map<String, dynamic> data, String uid) async {
//     try {
//       await importsRef.doc('retailer').collection(uid).add(data);
//     } catch (e) {
//       print("Error creating product: $e");
//     }
//   }

//   // Read
//   Stream<QuerySnapshot> getProducts(String uid) {
//     return importsRef.doc('retailer').collection(uid).snapshots();
//   }

//   // Update
//   Future<void> updateProduct(
//       String id, Map<String, dynamic> data, String uid) async {
//     try {
//       await importsRef.doc('retailer').collection(uid).doc(id).update(data);
//     } catch (e) {
//       print("Error updating product: $e");
//     }
//   }

//   // Delete
//   Future<void> deleteProduct(String id, String uid) async {
//     try {
//       await importsRef.doc('retailer').collection(uid).doc(id).delete();
//     } catch (e) {
//       print("Error deleting product: $e");
//     }
//   }
// }
