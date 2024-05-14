import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:supplink/Backend/firebase/tradeservices.dart';

class ImportsPlutoGrid extends StatefulWidget {
  final FirebaseService firebaseService;

  const ImportsPlutoGrid({super.key, required this.firebaseService});

  @override
  State<ImportsPlutoGrid> createState() => _ImportsPlutoGridState();
}

class _ImportsPlutoGridState extends State<ImportsPlutoGrid> {
  final columns = [
    PlutoColumn(
      title: 'Product Name',
      field: 'product',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Quantity',
      field: 'quantity',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Price',
      field: 'price',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Supplier',
      field: 'supplier',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Date of Import',
      field: 'importDate',
      type: PlutoColumnType.date(),
    ),
  ];

  Stream<QuerySnapshot>? productsStream;
  PlutoGridStateManager? stateManager;

  @override
  void initState() {
    super.initState();
    productsStream = widget.firebaseService.getProducts();
    // print(productsStream);
    // print('dsfds');
  }

  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController importdateController = TextEditingController();

  late String productId;

  void addProduct(BuildContext context) async {
    if (productNameController.text.isEmpty ||
        quantityController.text.isEmpty ||
        priceController.text.isEmpty ||
        supplierController.text.isEmpty ||
        importdateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('fill the remaining product deatils')));
    }
    final product = {
      'product': productNameController.text,
      'quantity': int.parse(quantityController.text),
      'price': int.parse(priceController.text),
      'supplier': supplierController.text,
      'importDate': importdateController.text,
    };
    if (stateManager != null) {
      PlutoRow newRow = PlutoRow(cells: {
        'product': PlutoCell(value: product['product']),
        'quantity': PlutoCell(value: product['quantity']),
        'price': PlutoCell(value: product['price']),
        'supplier': PlutoCell(value: product['supplier']),
        'importDate': PlutoCell(value: product['importDate']),
      });

      stateManager!.insertRows(0, [newRow]);
    } else {
      // print("statemanager is null");
    }
    await widget.firebaseService.createProduct(product);
    Navigator.of(context).pop();
    productNameController.clear();
    quantityController.clear();
    priceController.clear();
    supplierController.clear();
    importdateController.clear();
  }

  void editProduct(String productId) async {
    try {
      final snapshot =
          await widget.firebaseService.getProductHavingProductId(productId);

      Map<String, dynamic> productData =
          snapshot.data() as Map<String, dynamic>;

      setState(() {
        productNameController.text = productData['product'] ?? '';
        quantityController.text = (productData['quantity'] ?? 0).toString();
        priceController.text = (productData['price'] ?? 0).toString();
        supplierController.text = productData['supplier'] ?? '';
        importdateController.text = productData['importDate'] ?? '';
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: _buildEditProductForm(productId),
        ),
      );
    } catch (e) {
      print('Error fetching product data: $e');
    }
  }

  void updateProduct(String productId, Map<String, dynamic> updatedData) async {
    await widget.firebaseService.updateProduct(productId, updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: productsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const Text('No products found'),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        // Form for adding a new product
                        content: _buildAddProductForm(),
                      ),
                    ),
                    child: const Text('Add Product'),
                  ),
                ],
              ),
            );
          } else {
            // final data = snapshot.data!.docs.map;
            // print('dddddddddddddddddddddddd');
            // print(data);

            return Column(
              children: [
                Expanded(
                  child: PlutoGrid(
                    columns: columns,
                    rows: snapshot.data!.docs.map((data) {
                      // productId = data.id;
                      return PlutoRow(key: Key(data.id), cells: {
                        'product': PlutoCell(value: data['product']),
                        'quantity': PlutoCell(value: data['quantity']),
                        'price': PlutoCell(value: data['price']),
                        'supplier': PlutoCell(value: data['supplier']),
                        'importDate':
                            PlutoCell(value: data['importDate'] ?? ''),
                        // '_key': PlutoCell(value: data['_key']), // Unique identifier
                      });
                    }).toList(),
                    onLoaded: (manager) {
                      stateManager = manager.stateManager;
                    },
                    onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event) {
                      String productId = event.row.key.toString();
                      int len = productId.length;

                      productId = productId.substring(3, len - 3);
                      // print('Double-tapped on row with ID: $productId');
                      editProduct(productId);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      // Form for adding a new product
                      content: _buildAddProductForm(),
                    ),
                  ),
                  child: const Text('Add Product'),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          }
        });
  }

  Widget _buildAddProductForm() {
    return SizedBox(
      height: 500,
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: productNameController,
            decoration: const InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: quantityController,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(labelText: 'Price'),
          ),
          TextField(
            controller: supplierController,
            decoration: const InputDecoration(labelText: 'supplier'),
          ),
          // TextField(
          //   controller: importdateController,
          //   decoration: const InputDecoration(labelText: 'Import Date'),
          // ),
          TextFormField(
            controller: importdateController,
            decoration: const InputDecoration(
              labelText: 'Import Date',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null && pickedDate != DateTime.now()) {
                importdateController.text =
                    "${pickedDate.toLocal()}".split(' ')[0];
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              addProduct(context);
            },
            child: const Text('Add Product'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProductForm(String productid) {
    return SizedBox(
      height: 500,
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: productNameController,
            decoration: const InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: quantityController,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(labelText: 'Price'),
          ),
          TextField(
            controller: supplierController,
            decoration: const InputDecoration(labelText: 'supplier'),
          ),
          TextFormField(
            controller: importdateController,
            decoration: const InputDecoration(
              labelText: 'Import Date',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null && pickedDate != DateTime.now()) {
                importdateController.text =
                    "${pickedDate.toLocal()}".split(' ')[0];
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              updateProduct(productid, {
                'product': productNameController.text,
                'quantity': int.tryParse(quantityController.text) ?? 0,
                'price': int.tryParse(priceController.text) ?? 0,
                'supplier': supplierController.text,
                'importDate': importdateController.text,
              });
              Navigator.of(context).pop();
            },
            child: const Text('update Product'),
          ),
        ],
      ),
    );
  }
}

class ExportsPlutoGrid extends StatefulWidget {
  final FirebaseService firebaseService;

  const ExportsPlutoGrid({super.key, required this.firebaseService});

  @override
  State<ExportsPlutoGrid> createState() => _ExportsPlutoGridState();
}

class _ExportsPlutoGridState extends State<ExportsPlutoGrid> {
  final columns = [
    PlutoColumn(
      title: 'Product Name',
      field: 'product',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Quantity',
      field: 'quantity',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Price',
      field: 'price',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Supplier',
      field: 'supplier',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Date of Import',
      field: 'importDate',
      type: PlutoColumnType.date(),
    ),
  ];

  Stream<QuerySnapshot>? productsStream;
  PlutoGridStateManager? stateManager;

  @override
  void initState() {
    super.initState();
    productsStream = widget.firebaseService.getProducts();
    // print(productsStream);
    // print('dsfds');
  }

  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController importdateController = TextEditingController();

  late String productId;

  void addProduct() async {
    if (productNameController.text.isEmpty ||
        quantityController.text.isEmpty ||
        priceController.text.isEmpty ||
        supplierController.text.isEmpty ||
        importdateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('fill the remaining product deatils')));
    }
    final product = {
      'product': productNameController.text,
      'quantity': int.parse(quantityController.text),
      'price': int.parse(priceController.text),
      'supplier': supplierController.text,
      'importDate': importdateController.text,
    };
    if (stateManager != null) {
      PlutoRow newRow = PlutoRow(cells: {
        'product': PlutoCell(value: product['product']),
        'quantity': PlutoCell(value: product['quantity']),
        'price': PlutoCell(value: product['price']),
        'supplier': PlutoCell(value: product['supplier']),
        'importDate': PlutoCell(value: product['importDate']),
      });

      stateManager!.insertRows(0, [newRow]);
    } else {
      // print("statemanager is null");
    }
    await widget.firebaseService.createProduct(product);
    Navigator.of(context).pop();
    productNameController.clear();
    quantityController.clear();
    priceController.clear();
    supplierController.clear();
    importdateController.clear();
  }

  void editProduct(String productId) async {
    try {
      final snapshot =
          await widget.firebaseService.getProductHavingProductId(productId);

      Map<String, dynamic> productData =
          snapshot.data() as Map<String, dynamic>;

      setState(() {
        productNameController.text = productData['product'] ?? '';
        quantityController.text = (productData['quantity'] ?? 0).toString();
        priceController.text = (productData['price'] ?? 0).toString();
        supplierController.text = productData['supplier'] ?? '';
        importdateController.text = productData['importDate'] ?? '';
      });

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          content: _buildEditProductForm(productId),
        ),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching product data: $e');
    }
  }

  void updateProduct(String productId, Map<String, dynamic> updatedData) async {
    await widget.firebaseService.updateProduct(productId, updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: productsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const Text('No products found'),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        // Form for adding a new product
                        content: _buildAddProductForm(),
                      ),
                    ),
                    child: const Text('Add Product'),
                  ),
                ],
              ),
            );
          } else {
            // final data = snapshot.data!.docs.map;
            // print('dddddddddddddddddddddddd');
            // print(data);

            return Column(
              children: [
                Expanded(
                  child: PlutoGrid(
                    columns: columns,
                    rows: snapshot.data!.docs.map((data) {
                      // productId = data.id;
                      return PlutoRow(key: Key(data.id), cells: {
                        'product': PlutoCell(value: data['product']),
                        'quantity': PlutoCell(value: data['quantity']),
                        'price': PlutoCell(value: data['price']),
                        'supplier': PlutoCell(value: data['supplier']),
                        'importDate':
                            PlutoCell(value: data['importDate'] ?? ''),
                        // '_key': PlutoCell(value: data['_key']), // Unique identifier
                      });
                    }).toList(),
                    onLoaded: (manager) {
                      stateManager = manager.stateManager;
                    },
                    onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event) {
                      String productId = event.row.key.toString();
                      int len = productId.length;

                      productId = productId.substring(3, len - 3);
                      // print('Double-tapped on row with ID: $productId');
                      editProduct(productId);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      // Form for adding a new product
                      content: _buildAddProductForm(),
                    ),
                  ),
                  child: const Text('Add Product'),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          }
        });
  }

  Widget _buildAddProductForm() {
    return SizedBox(
      height: 500,
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: productNameController,
            decoration: const InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: quantityController,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(labelText: 'Price'),
          ),
          TextField(
            controller: supplierController,
            decoration: const InputDecoration(labelText: 'supplier'),
          ),
          // TextField(
          //   controller: importdateController,
          //   decoration: const InputDecoration(labelText: 'Import Date'),
          // ),
          TextFormField(
            controller: importdateController,
            decoration: const InputDecoration(
              labelText: 'Import Date',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null && pickedDate != DateTime.now()) {
                importdateController.text =
                    "${pickedDate.toLocal()}".split(' ')[0];
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              addProduct();
            },
            child: const Text('Add Product'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProductForm(String productid) {
    return SizedBox(
      height: 500,
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: productNameController,
            decoration: const InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: quantityController,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(labelText: 'Price'),
          ),
          TextField(
            controller: supplierController,
            decoration: const InputDecoration(labelText: 'supplier'),
          ),
          TextFormField(
            controller: importdateController,
            decoration: const InputDecoration(
              labelText: 'Import Date',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null && pickedDate != DateTime.now()) {
                importdateController.text =
                    "${pickedDate.toLocal()}".split(' ')[0];
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              updateProduct(productid, {
                'product': productNameController.text,
                'quantity': int.tryParse(quantityController.text) ?? 0,
                'price': int.tryParse(priceController.text) ?? 0,
                'supplier': supplierController.text,
                'importDate': importdateController.text,
              });
              Navigator.of(context).pop();
            },
            child: const Text('update Product'),
          ),
        ],
      ),
    );
  }
}

















// import 'package:flutter/material.dart';
// import 'package:pluto_grid/pluto_grid.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:supplink/Backend/firebase/tradeservices.dart';

// class ImportsPlutoGrid extends StatefulWidget {
//   final FirebaseService firebaseService;
//   final String gridType; // This will distinguish between Imports and Exports

//   ImportsPlutoGrid({Key? key, required this.firebaseService, required this.gridType})
//       : super(key: key);

//   @override
//   State<ImportsPlutoGrid> createState() => _ImportsPlutoGridState();
// }

// class _ImportsPlutoGridState extends State<ImportsPlutoGrid> {
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
//       title: 'Supplier/Customer',
//       field: 'supplierOrCustomer',
//       type: PlutoColumnType.text(),
//     ),
//     PlutoColumn(
//       title: 'Date',
//       field: 'date',
//       type: PlutoColumnType.date(),
//     ),
//   ];

//   Stream<QuerySnapshot>? recordsStream;
//   PlutoGridStateManager? stateManager;

//   @override
//   void initState() {
//     super.initState();
//     recordsStream = widget.firebaseService.getRecords();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: recordsStream,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }

//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.data!.docs.isEmpty) {
//           return Center(
//             child: Column(
//               children: [
//                 const Text('No records found'),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () => _showAddRecordDialog(),
//                   child: const Text('Add Record'),
//                 ),
//               ],
//             ),
//           );
//         }

//         return Column(
//           children: [
//             Expanded(
//               child: PlutoGrid(
//                 columns: columns,
//                 rows: snapshot.data!.docs.map((doc) {
//                   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//                   return PlutoRow(cells: {
//                     'product': PlutoCell(value: data['product']),
//                     'quantity': PlutoCell(value: data['quantity']),
//                     'price': PlutoCell(value: data['price']),
//                     'supplierOrCustomer': PlutoCell(value: data['supplierOrCustomer']),
//                     'date': PlutoCell(value: _formatDate(data['date'])),
//                   });
//                 }).toList(),
//                 onLoaded: (manager) {
//                   stateManager = manager.stateManager;
//                 },
//                 // Add other PlutoGrid callbacks as needed
//               ),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () => _showAddRecordDialog(),
//               child: const Text('Add Record'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _showAddRecordDialog() async {
//     String defaultProduct = '';
//     int defaultQuantity = 0;
//     double defaultPrice = 0.0;
//     String defaultSupplierOrCustomer = '';
//     DateTime defaultDate = DateTime.now();

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add Record'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               decoration: InputDecoration(labelText: 'Product Name'),
//               onChanged: (value) => defaultProduct = value,
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Quantity'),
//               keyboardType: TextInputType.number,
//               onChanged: (value) => defaultQuantity = int.tryParse(value) ?? 0,
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Price'),
//               keyboardType: TextInputType.number,
//               onChanged: (value) => defaultPrice = double.tryParse(value) ?? 0.0,
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Supplier/Customer'),
//               onChanged: (value) => defaultSupplierOrCustomer = value,
//             ),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Date',
//                 suffixIcon: Icon(Icons.calendar_today),
//               ),
//               readOnly: true,
//               controller: TextEditingController(text: _formatDate(defaultDate)),
//               onTap: () async {
//                 final DateTime? pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: defaultDate,
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2100),
//                 );
//                 if (pickedDate != null && pickedDate != defaultDate) {
//                   setState(() {
//                     defaultDate = pickedDate;
//                   });
//                 }
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Map<String, dynamic> newData = {
//                 'product': defaultProduct,
//                 'quantity': defaultQuantity,
//                 'price': defaultPrice,
//                 'supplierOrCustomer': defaultSupplierOrCustomer,
//                 'date': defaultDate,
//               };
//               widget.firebaseService.createRecord(newData);
//               Navigator.of(context).pop();
//             },
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime? timestamp) {
//     if (timestamp == null) {
//       return '';
//     }
//     DateTime dateTime = timestamp;
//     return DateFormat('yyyy-MM-dd').format(dateTime);
//   }
// }
