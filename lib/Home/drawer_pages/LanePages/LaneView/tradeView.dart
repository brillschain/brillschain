import 'package:flutter/material.dart';
// import 'package:pluto_grid/pluto_grid.dart';
import 'package:supplink/Backend/firebase/tradeservices.dart';
import 'package:supplink/Home/drawer_pages/LanePages/LaneView/imports/imports.dart';

class TradeView extends StatefulWidget {
  final String contractServerId;
  final String userAuthId;
  final String laneId;

  const TradeView(this.contractServerId, this.userAuthId, this.laneId,
      {super.key});

  @override
  State<TradeView> createState() => _TradeViewState();
}

class _TradeViewState extends State<TradeView> {
  int importsView = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: importsView == 1
                        ? MaterialStateProperty.all<Color>(Colors.black)
                        : MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 206, 206, 206)),
                  ),
                  onPressed: () {
                    setState(() {
                      importsView = 1;
                    });
                  },
                  child: const Text('Imports'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: importsView == 0
                        ? MaterialStateProperty.all<Color>(Colors.black)
                        : MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 206, 206, 206)),
                  ),
                  onPressed: () {
                    setState(() {
                      importsView = 0;
                    });
                  },
                  child: const Text('Exports'),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 400,
              child: Card(
                elevation: 2,
                child: importsView == 1
                    ? ImportsPlutoGrid(
                        firebaseService: FirebaseService(
                            widget.contractServerId,
                            widget.userAuthId,
                            widget.laneId,
                            'Imports'),
                      )
                    : ExportsPlutoGrid(
                        firebaseService: FirebaseService(
                            widget.contractServerId,
                            widget.userAuthId,
                            widget.laneId,
                            'Exports'),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}












































































// class ImportsPlutoGrid extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final columns = [
//       PlutoColumn(
//         title: 'Product Name',
//         field: 'product',
//         type: PlutoColumnType.text(),
//       ),
//       PlutoColumn(
//         title: 'Quantity',
//         field: 'quantity',
//         type: PlutoColumnType.number(),
//       ),
//       PlutoColumn(
//         title: 'Price',
//         field: 'price',
//         type: PlutoColumnType.number(),
//       ),
//       PlutoColumn(
//         title: 'Supplier',
//         field: 'supplier',
//         type: PlutoColumnType.text(),
//       ),
//       PlutoColumn(
//         title: 'Date of Import',
//         field: 'importDate',
//         type: PlutoColumnType.date(),
//       ),
//     ];

//     final rows = [
//       PlutoRow(
//         cells: {
//           'product': PlutoCell(value: 'Product A'),
//           'quantity': PlutoCell(value: 100),
//           'price': PlutoCell(value: 50.0),
//           'supplier': PlutoCell(value: 'Supplier X'),
//           'importDate': PlutoCell(value: DateTime.now()),
//         },
//       ),
//       PlutoRow(
//         cells: {
//           'product': PlutoCell(value: 'Product B'),
//           'quantity': PlutoCell(value: 150),
//           'price': PlutoCell(value: 75.0),
//           'supplier': PlutoCell(value: 'Supplier Y'),
//           'importDate': PlutoCell(value: DateTime.now()),
//         },
//       ),
//     ];

//     return PlutoGrid(
//       columns: columns,
//       rows: rows,
//     );
//   }
// }

// class ExportsPlutoGrid extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final columns = [
//       PlutoColumn(
//         title: 'Product Name',
//         field: 'product',
//         type: PlutoColumnType.text(),
//       ),
//       PlutoColumn(
//         title: 'Quantity',
//         field: 'quantity',
//         type: PlutoColumnType.number(),
//       ),
//       PlutoColumn(
//         title: 'Price',
//         field: 'price',
//         type: PlutoColumnType.number(),
//       ),
//       PlutoColumn(
//         title: 'Customer',
//         field: 'customer',
//         type: PlutoColumnType.text(),
//       ),
//       PlutoColumn(
//         title: 'Date of Export',
//         field: 'exportDate',
//         type: PlutoColumnType.date(),
//       ),
//     ];

//     final rows = [
//       PlutoRow(
//         cells: {
//           'product': PlutoCell(value: 'Product X'),
//           'quantity': PlutoCell(value: 200),
//           'price': PlutoCell(value: 80.0),
//           'customer': PlutoCell(value: 'Customer A'),
//           'exportDate': PlutoCell(value: DateTime.now()),
//         },
//       ),
//       PlutoRow(
//         cells: {
//           'product': PlutoCell(value: 'Product Y'),
//           'quantity': PlutoCell(value: 120),
//           'price': PlutoCell(value: 60.0),
//           'customer': PlutoCell(value: 'Customer B'),
//           'exportDate': PlutoCell(value: DateTime.now()),
//         },
//       ),
//     ];

//     return PlutoGrid(
//       columns: columns,
//       rows: rows,
//     );
//   }
// }
