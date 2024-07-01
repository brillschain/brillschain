import 'package:flutter/material.dart';

class DetailsRow extends StatelessWidget {
  final IconData icon;
  final String data;
  const DetailsRow({super.key, required this.icon, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(
            width: 10,
          ),
          Text(data),
        ],
      ),
    );
  }
}
