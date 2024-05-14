// import 'dart:html';
// import 'dart:js_interop';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pluto_grid/pluto_grid.dart';
// import 'package:supplink/Backend/firebase/tradeservices.dart';

// class ManufactureImports extends StatefulWidget {
//   final FirebaseService_Manufactures firebaseService_Manufacture;

//   const ManufactureImports(
//       {Key? key, required this.firebaseService_Manufacture})
//       : super(key: key);

//   @override
//   State<ManufactureImports> createState() => _ManufactureImportsState();
// }

// class _ManufactureImportsState extends State<ManufactureImports> {
//   final columns = [
//     PlutoColumn(
//       title: 'Product Name',
//       field: 'product',
//       type: PlutoColumnType.text(),
//     ),
//     PlutoColumn(
//       title: 'Quantity',
//       field: 'quantity',
//       type: PlutoColumnType.number(),
//     ),
//     PlutoColumn(
//       title: 'Price',
//       field: 'price',
//       type: PlutoColumnType.number(),
//     ),
//     PlutoColumn(
//       title: 'Supplier',
//       field: 'supplier',
//       type: PlutoColumnType.text(),
//     ),
//     PlutoColumn(
//       title: 'Date of Import',
//       field: 'importDate',
//       type: PlutoColumnType.date(),
//     ),
//   ];

//   Stream<QuerySnapshot>? productsStream;
//   PlutoGridStateManager? stateManager;
//   final user = FirebaseAuth.instance.currentUser;

//   @override
//   void initState() {
//     super.initState();
//     productsStream = widget.firebaseService_Manufacture.getProducts(user!.uid);
//   }

//   TextEditingController productNameController = TextEditingController();
//   TextEditingController quantityController = TextEditingController();
//   TextEditingController priceController = TextEditingController();
//   TextEditingController supplierController = TextEditingController();
//   TextEditingController importdateController = TextEditingController();

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late String productId;

//   void addProduct() async {
//     // Validate user input (optional)
//     if (productNameController.text.isEmpty ||
//         quantityController.text.isEmpty ||
//         priceController.text.isEmpty ||
//         supplierController.text.isEmpty ||
//         importdateController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('fill the remaining product deatils')));
//     }
//     final product = {
//       'product': productNameController.text,
//       'quantity': int.parse(quantityController.text),
//       'price': int.parse(priceController.text),
//       'supplier': supplierController.text,
//       'importDate': importdateController.text,
//     };
//     if (stateManager != null) {
//       PlutoRow newRow = PlutoRow(cells: {
//         'product': PlutoCell(value: product['product']),
//         'quantity': PlutoCell(value: product['quantity']),
//         'price': PlutoCell(value: product['price']),
//         'supplier': PlutoCell(value: product['supplier']),
//         'importDate': PlutoCell(value: product['importDate']),
//       });

//       stateManager!.insertRows(0, [newRow]);
//     } else {
//       print("statemanager is null");
//     }
//     await widget.firebaseService_Manufacture.createProduct(product, user!.uid);
//     Navigator.of(context).pop();

//     productNameController.clear();
//     quantityController.clear();
//     priceController.clear();
//     supplierController.clear();
//     importdateController.clear();
//   }

//   void editProduct(String productId) async {
//     try {
//       final snapshot =
//           await _firestore.collection('Imports').doc(productId).get();
//       print(productId);
//       print(snapshot);
//       Map<String, dynamic> productData = snapshot.data() ?? {};
//       print(productData);

//       if (productData != null) {
//         setState(() {
//           productNameController.text = productData['product'] ?? '';
//           quantityController.text = (productData['quantity'] ?? 0).toString();
//           priceController.text = (productData['price'] ?? 0).toString();
//           supplierController.text = productData['supplier'] ?? '';
//           importdateController.text = productData['importDate'] ?? '';
//         });

//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             content: _buildEditProductForm(productId),
//           ),
//         );
//       } else {
//         print('Product data is null');
//       }
//     } catch (e) {
//       print('Error fetching product data: $e');
//     }
//   }

//   void updateProduct(String productId, Map<String, dynamic> updatedData) async {
//     await widget.firebaseService_Manufacture
//         .updateProduct(productId, updatedData, user!.uid);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: productsStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Column(
//                 children: [
//                   const Text('No products found'),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   ElevatedButton(
//                     onPressed: () => showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         // Form for adding a new product
//                         content: _buildAddProductForm(),
//                       ),
//                     ),
//                     child: const Text('Add Product'),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             // final data = snapshot.data!.docs.map;
//             return Column(
//               children: [
//                 Expanded(
//                   child: PlutoGrid(
//                     columns: columns,
//                     rows: snapshot.data!.docs.map((data) {
//                       // productId = data.id;
//                       return PlutoRow(key: Key(data.id), cells: {
//                         'product': PlutoCell(value: data['product']),
//                         'quantity': PlutoCell(value: data['quantity']),
//                         'price': PlutoCell(value: data['price']),
//                         'supplier': PlutoCell(value: data['supplier']),
//                         'importDate':
//                             PlutoCell(value: data['importDate'] ?? ''),
//                         // '_key': PlutoCell(value: data['_key']), // Unique identifier
//                       });
//                     }).toList(),
//                     onLoaded: (manager) {
//                       stateManager = manager.stateManager;
//                     },
//                     onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event) {
//                       String productId = event.row.key.toString();
//                       int len = productId.length;

//                       productId = productId.substring(3, len - 3);
//                       print('Double-tapped on row with ID: $productId');
//                       editProduct(productId);
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 ElevatedButton(
//                   onPressed: () => showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       // Form for adding a new product
//                       content: _buildAddProductForm(),
//                     ),
//                   ),
//                   child: const Text('Add Product'),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 // ElevatedButton(
//                 //   onPressed: () => editProduct(productId),
//                 //   child: const Text('Update Product'),
//                 // ),
//               ],
//             );
//           }
//         });
//   }

//   Widget _buildAddProductForm() {
//     return Container(
//       height: 500,
//       width: 400,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: productNameController,
//             decoration: const InputDecoration(labelText: 'Product Name'),
//           ),
//           TextField(
//             controller: quantityController,
//             decoration: const InputDecoration(labelText: 'Quantity'),
//           ),
//           TextField(
//             controller: priceController,
//             decoration: const InputDecoration(labelText: 'Price'),
//           ),
//           TextField(
//             controller: supplierController,
//             decoration: const InputDecoration(labelText: 'supplier'),
//           ),
//           TextFormField(
//             controller: importdateController,
//             decoration: const InputDecoration(
//               labelText: 'Import Date',
//               suffixIcon: Icon(Icons.calendar_today),
//             ),
//             onTap: () async {
//               DateTime? pickedDate = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(2101),
//               );

//               if (pickedDate != null && pickedDate != DateTime.now()) {
//                 importdateController.text =
//                     "${pickedDate.toLocal()}".split(' ')[0];
//               }
//             },
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           ElevatedButton(
//             onPressed: () {
//               addProduct();
//             },
//             child: const Text('Add Product'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEditProductForm(String productid) {
//     return Container(
//       height: 500,
//       width: 400,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: productNameController,
//             decoration: const InputDecoration(labelText: 'Product Name'),
//           ),
//           TextField(
//             controller: quantityController,
//             decoration: const InputDecoration(labelText: 'Quantity'),
//           ),
//           TextField(
//             controller: priceController,
//             decoration: const InputDecoration(labelText: 'Price'),
//           ),
//           TextField(
//             controller: supplierController,
//             decoration: const InputDecoration(labelText: 'supplier'),
//           ),
//           TextFormField(
//             controller: importdateController,
//             decoration: const InputDecoration(
//               labelText: 'Import Date',
//               suffixIcon: Icon(Icons.calendar_today),
//             ),
//             onTap: () async {
//               DateTime? pickedDate = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(2101),
//               );

//               if (pickedDate != null && pickedDate != DateTime.now()) {
//                 importdateController.text =
//                     "${pickedDate.toLocal()}".split(' ')[0];
//               }
//             },
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           ElevatedButton(
//             onPressed: () {
//               updateProduct(productid, {
//                 'product': productNameController.text,
//                 'quantity': int.tryParse(quantityController.text) ?? 0,
//                 'price': int.tryParse(priceController.text) ?? 0,
//                 'supplier': supplierController.text,
//                 'importDate': importdateController.text,
//               });
//               Navigator.of(context).pop();
//             },
//             child: const Text('update Product'),
//           ),
//         ],
//       ),
//     );
//   }
// }
