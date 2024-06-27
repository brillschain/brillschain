import 'package:flutter/material.dart';

class ContractList extends StatefulWidget {
  const ContractList({super.key});

  @override
  State<ContractList> createState() => _ContractListState();
}

class _ContractListState extends State<ContractList>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  final List<Contract> contracts = [
    Contract(
        date: '25.05.2024',
        status: 'Scheduled',
        product: 'product1',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '27.05.2024',
        status: 'Scheduled',
        product: 'product2',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '30.05.2024',
        status: 'Scheduled',
        product: 'product3',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '15.05.2024',
        status: 'Cancelled',
        product: 'product4',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '21.05.2024',
        status: 'Ongoing',
        product: 'product5',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '25.05.2024',
        status: 'Completed',
        product: 'product1',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '27.05.2024',
        status: 'Completed',
        product: 'product2',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '30.05.2024',
        status: 'Completed',
        product: 'product3',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '15.05.2024',
        status: 'Cancelled',
        product: 'product4',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
    Contract(
        date: '21.05.2024',
        status: 'Ongoing',
        product: 'product5',
        from: '4100 Hutchinson River Apt.5H',
        to: '52-34 Van Dam St rm603'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(controller: tabController, tabs: const [
        Tab(text: 'Scheduled'),
        Tab(text: 'Ongoing'),
        Tab(text: 'Completed'),
        Tab(text: 'Cancelled'),
      ]),
      body: TabBarView(
        controller: tabController,
        children: [
          contractListCardTrail('Scheduled', const Color(0xff3398F6)),
          contractListCardTrail('Ongoing', const Color(0xff3EE094)),
          contractListCardTrail('Completed', const Color(0xffD95AF3)),
          contractListCardTrail('Cancelled', const Color(0xffFA4A42)),
        ],
      ),
    );
  }

  Widget contractListCardTrail(String status, Color color) {
    final filteredContracts =
        contracts.where((c) => c.status == status).toList();
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('date',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('status',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('product',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('from',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('to',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    width: 0,
                  )
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: filteredContracts.length,
                itemBuilder: (context, index) {
                  return ContractItem(
                    contract: filteredContracts[index],
                    color: color,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Contract {
  final String date;
  final String status;
  final String product;
  final String from;
  final String to;

  Contract(
      {required this.date,
      required this.status,
      required this.product,
      required this.from,
      required this.to});
}

class ContractItem extends StatelessWidget {
  final Contract contract;
  final Color color;

  const ContractItem({super.key, required this.contract, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const SizedBox(
          //   width: 5,
          // ),
          Text(contract.date, style: const TextStyle(fontSize: 14)),
          Text(contract.status, style: TextStyle(fontSize: 14, color: color)),
          // const SizedBox(
          //   width: 10,
          // ),
          Text(contract.product, style: const TextStyle(fontSize: 14)),
          // const SizedBox(
          //   width: 30,
          // ),
          Text(contract.from, style: const TextStyle(fontSize: 14)),
          // const Text("To"),
          Text(contract.to, style: const TextStyle(fontSize: 14)),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(contract.from, style: const TextStyle(fontSize: 14)),
          //     const Text("To"),
          //     Text(contract.to, style: const TextStyle(fontSize: 14)),
          //   ],
          // )
        ],
      ),
    );
  }
}
