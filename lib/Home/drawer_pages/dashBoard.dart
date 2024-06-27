// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:supplink/utils/constants.dart';
import 'package:editable/editable.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
// import 'package:supplink/main.dart';
import 'package:supplink/Home/model.dart';

class DashBoard extends StatefulWidget {
  static const String routeName = '/DashBoard';

  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final _editableKey = GlobalKey<EditableState>();
  // final PaginationController _paginationController = PaginationController(
  //   rowCount: many_products.length,
  //   rowsPerPage: 10,
  // );

  void _addNewRow() {
    setState(() {
      _editableKey.currentState?.createRow();
    });
  }

  List rows = [
    {
      "name": 'James Peter',
      "date": '01/08/2007',
      "month": 'March',
      "status": 'beginner'
    },
    {
      "name": 'James Peter',
      "date": '01/08/2007',
      "month": 'March',
      "status": 'beginner'
    },
    {
      "name": 'James Peter',
      "date": '01/08/2007',
      "month": 'March',
      "status": 'beginner'
    },
    {
      "name": 'James Peter',
      "date": '01/08/2007',
      "month": 'March',
      "status": 'beginner'
    },
  ];

  //Headers or Columns
  List headers = [
    {"title": 'Name', 'index': 1, 'key': 'name'},
    {"title": 'Name', 'index': 1, 'key': 'name'},
    {"title": 'Name', 'index': 1, 'key': 'name'},
    {"title": 'Name', 'index': 1, 'key': 'name'},
  ];

  @override
  Widget build(BuildContext context) {
    // var columns = products.first.keys.toList();

    return Scaffold(
      appBar: myAppBar,
      body: Column(
        children: [
          SizedBox(
            height: 256,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 3,
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Card(
                        elevation: 3,
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 400,
                        ),
                      ),
                    ),
                  )
                ],
                // Add more options to alter the table like expand to full space etc.,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(20)),
                            backgroundColor:
                                const WidgetStatePropertyAll<Color>(
                                    Colors.blue),
                          ),
                          onPressed: _addNewRow,
                          child: const Text(
                            'Add Row',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(20)),
                            backgroundColor:
                                const WidgetStatePropertyAll<Color>(
                                    Colors.blue),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Add Column',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Divider(),
                  const Expanded(child: MyHomePage(title: 'title'))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final PaginationController _paginationController = PaginationController(
    rowCount: many_products.length,
    rowsPerPage: 10,
  );
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    var columns = products.first.keys.toList();

    return ListView(
      // Scrolling should be off
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
              height: 50,
              color: const Color.fromARGB(255, 48, 48, 48),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: BorderSide.strokeAlignOutside,
                controller: tabController,
                tabs: const [
                  Tab(text: "Imports"),
                  Tab(text: "Exports"),
                ],
              ),
            ))
          ],
        ),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: tabController,
            children: [
              // simple
              ScrollableTableView(
                headers: columns.map((column) {
                  return TableViewHeader(
                    label: column,
                  );
                }).toList(),
                rows: products.map((product) {
                  return TableViewRow(
                    height: 60,
                    cells: columns.map((column) {
                      return TableViewCell(
                        child: Text(product[column] ?? ""),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
              // paginated
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ValueListenableBuilder(
                        valueListenable: _paginationController,
                        builder: (context, value, child) {
                          return Row(
                            children: [
                              Text(
                                  "${_paginationController.currentPage}  of ${_paginationController.pageCount}"),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed:
                                        _paginationController.currentPage <= 1
                                            ? null
                                            : () {
                                                _paginationController
                                                    .previous();
                                              },
                                    iconSize: 20,
                                    splashRadius: 20,
                                    icon: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color:
                                          _paginationController.currentPage <= 1
                                              ? Colors.black26
                                              : Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed:
                                        _paginationController.currentPage >=
                                                _paginationController.pageCount
                                            ? null
                                            : () {
                                                _paginationController.next();
                                              },
                                    iconSize: 20,
                                    splashRadius: 20,
                                    icon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: _paginationController
                                                  .currentPage >=
                                              _paginationController.pageCount
                                          ? Colors.black26
                                          : Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                  ),
                  Expanded(
                    child: ScrollableTableView(
                      paginationController: _paginationController,
                      headers: columns.map((column) {
                        return TableViewHeader(
                          label: column,
                        );
                      }).toList(),
                      rows: many_products.map((product) {
                        return TableViewRow(
                          height: 60,
                          cells: columns.map((column) {
                            return TableViewCell(
                              child: Text(product[column] ?? ""),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
