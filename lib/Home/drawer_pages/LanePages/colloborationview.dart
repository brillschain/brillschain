import 'package:flutter/material.dart';

class ColloborativeCreation extends StatefulWidget {
  const ColloborativeCreation({super.key});

  @override
  State<ColloborativeCreation> createState() => _ColloborativeCreationState();
}

class _ColloborativeCreationState extends State<ColloborativeCreation> {
  TextEditingController changeDomain = TextEditingController();
  bool changeDomainBool = false;
  int changeDomainIndex = -1;
  List<String> domainList = ['Farmer', 'Manufacture', 'Retailer', 'Supplier'];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    double listViewWidth = (screenWidth / 5);
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: screenWidth,
          child: ListView.separated(
            itemCount: domainList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SizedBox(
                width: listViewWidth,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: listViewWidth,
                      color: Colors.green,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              index > 0
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          String temp = domainList[index];
                                          domainList[index] =
                                              domainList[index - 1];
                                          domainList[index - 1] = temp;
                                        });
                                      },
                                      icon: const Icon(Icons.arrow_left),
                                    )
                                  : Container(),
                              if (index < domainList.length - 1)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      String temp = domainList[index];
                                      domainList[index] = domainList[index + 1];
                                      domainList[index + 1] = temp;
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_right),
                                ),
                            ],
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        changeDomainBool = true;
                                        changeDomainIndex = index;
                                      });
                                    },
                                    child: changeDomainIndex == index
                                        ? SizedBox(
                                            height: 40,
                                            width: 150,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller: changeDomain,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      changeDomainIndex = -1;
                                                    });
                                                  },
                                                  icon: const Icon(Icons.check_box),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Text(domainList[index]),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.more_horiz),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        domainList.insert(
                                            index + 1, 'New Designation');
                                      });
                                    },
                                    child: const Text('Add'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Add new member'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: 10,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 100,
                            color: const Color.fromARGB(255, 220, 218, 218),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: 10);
            },
          ),
        ),
      ),
    );
  }
}
