// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundcolor;
  final Color textColor;
  final Icon icon;
  final Function() function;
  final double width;
  const CustomButton(
    this.icon, {
    super.key,
    required this.function,
    required this.width,
    required this.text,
    required this.backgroundcolor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      borderRadius: BorderRadius.circular(15),
      splashColor: backgroundcolor,
      child: Container(
        margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.all(8),
        width: width,
        // height: 35,
        decoration: BoxDecoration(
            color: backgroundcolor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: textColor, width: 1)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              const SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: TextStyle(
                    backgroundColor: backgroundcolor,
                    color: textColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
