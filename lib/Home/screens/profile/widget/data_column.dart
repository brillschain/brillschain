import 'package:flutter/material.dart';

class UserDataColumn extends StatelessWidget {
  final String value;
  final String name;
  const UserDataColumn({super.key, required this.value, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          name,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        )
      ],
    );
  }
}
