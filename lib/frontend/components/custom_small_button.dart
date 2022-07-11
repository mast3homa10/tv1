import 'package:flutter/material.dart';

class CustomSmallButton extends StatelessWidget {
  const CustomSmallButton(
      {Key? key, required this.onPressed, required this.child})
      : super(key: key);
  final VoidCallback onPressed;

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Center(child: child));
  }
}
