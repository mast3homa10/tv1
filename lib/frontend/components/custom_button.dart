import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      this.label = 'کلیک',
      this.labelStyle,
      required this.onPressed,
      this.isPressed = false,
      this.height = 60,
      this.width = 100})
      : super(key: key);

  final VoidCallback onPressed;
  final String label;
  final TextStyle? labelStyle;
  final bool isPressed;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)))),
          onPressed: onPressed,
          child: Center(
              child: isPressed
                  ? const CircularProgressIndicator()
                  : Text(
                      label, //todo : change style
                      style: labelStyle ??
                          Theme.of(context).textTheme.button!.copyWith(
                              color: Theme.of(context).scaffoldBackgroundColor),
                    ))),
    );
  }
}
