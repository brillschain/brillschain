import 'package:flutter/material.dart';

class DetailsRow extends StatelessWidget {
  final IconData icon;
  final String data;
  const DetailsRow({super.key, required this.icon, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(
            width: 15,
          ),
          Text(data),
        ],
      ),
    );
  }
}
