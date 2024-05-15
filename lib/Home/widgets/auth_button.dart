import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthButton extends StatefulWidget {
  final Function function;
  final String text;
  final Color color;
  final Color textColor;
  final bool isloading;

  const AuthButton({
    super.key,
    required this.function,
    required this.text,
    required this.color,
    required this.textColor,
    required this.isloading,
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => widget.function(),
      style: ButtonStyle(
        side: MaterialStatePropertyAll(
          BorderSide(color: widget.color),
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        fixedSize: const MaterialStatePropertyAll(
          Size.fromWidth(250),
        ),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 20),
        ),
      ),
      child: widget.isloading
          ? Container(
              padding: const EdgeInsets.only(bottom: 50),
              height: 30,
              child: OverflowBox(
                minHeight: 50,
                maxHeight: 50,
                maxWidth: 120,
                minWidth: 100,
                child: Lottie.asset('animation/loading_animation.json',
                    fit: BoxFit.cover
                    // height: 200,
                    // width: 150,
                    ),
              ),
            )
          : Text(
              widget.text,
              style: TextStyle(
                color: widget.textColor,
              ),
            ),
    );
  }
}
