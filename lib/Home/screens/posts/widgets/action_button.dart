import 'package:flutter/material.dart';
import 'package:supplink/utils/hover_button.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.context,
    required this.icon,
    required this.label,
    required this.ontap,
  });

  final BuildContext context;
  final IconData icon;
  final String label;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: ontap,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        width: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(label)
          ],
        ),
      ),
    );
  }
}
