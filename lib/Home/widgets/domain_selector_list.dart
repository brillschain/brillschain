import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DomainSelectorList extends StatefulWidget {
  final ValueChanged<String> onItemSelected;

  const DomainSelectorList({
    super.key,
    required this.onItemSelected,
  });

  @override
  State<DomainSelectorList> createState() => _DomainSelectorListState();
}

class _DomainSelectorListState extends State<DomainSelectorList> {
  List<String> domainList = ['Farmer', 'Manufacture', 'Retailer', 'Supplier'];
  String itemSelected = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: DropdownSearch<String>(
        items: domainList,
        popupProps: const PopupProps.menu(
          showSearchBox: true,
        ),
        dropdownButtonProps: DropdownButtonProps(
          color: Colors.blue,
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          textAlignVertical: TextAlignVertical.center,
          dropdownSearchDecoration: InputDecoration(
            labelText: "Domain",
            hintText: "Domain in menu mode",
            border: OutlineInputBorder(),
          ),
        ),
        onChanged: (value) {
          setState(() {
            itemSelected = value.toString();
            widget.onItemSelected(itemSelected);
          });
        },
        selectedItem: itemSelected,
      ),
    );
  }
}
