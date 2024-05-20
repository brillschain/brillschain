import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthButton extends StatefulWidget {
  final Function function;
  final String text;
  final Color backgroundcolor;
  final Color textColor;
  final bool isloading;
  final double width;
  const AuthButton(
      {super.key,
      required this.function,
      required this.text,
      required this.backgroundcolor,
      required this.textColor,
      required this.isloading,
      required this.width});

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => widget.function(),
      style: ButtonStyle(
        side: const MaterialStatePropertyAll(
          BorderSide(color: Colors.black),
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        fixedSize: MaterialStatePropertyAll(
          Size.fromWidth(widget.width),
        ),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 20),
        ),
        backgroundColor: MaterialStatePropertyAll(widget.backgroundcolor),
      ),
      child: widget.isloading
          ? Center(
              child: CupertinoActivityIndicator(
                color: widget.textColor,
                radius: 10,
              ),
            )
          // ? Container(
          //     padding: const EdgeInsets.only(bottom: 50),
          //     height: 30,
          //     child: OverflowBox(
          //       minHeight: 50,
          //       maxHeight: 50,
          //       maxWidth: 120,
          //       minWidth: 100,
          //       child: Lottie.asset('animation/loading_animation.json',
          //           fit: BoxFit.cover
          //           // height: 200,
          //           // width: 150,
          //           ),
          //     ),
          //   )
          : Text(
              widget.text,
              style: TextStyle(
                color: widget.textColor,
              ),
            ),
    );
  }
}
