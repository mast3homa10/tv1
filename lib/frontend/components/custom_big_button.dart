import 'package:flutter/material.dart';

class CustomBigButton extends StatelessWidget {
  const CustomBigButton(
      {Key? key,
      this.label = 'کلیک',
      required this.onPressed,
      this.isPressed = false})
      : super(key: key);

  final VoidCallback onPressed;
  final String label;
  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
        child: SizedBox(
          height: 62,
          child: Center(
              child: isPressed
                  ? const CircularProgressIndicator()
                  : Text(
                      label, //todo : change style
                      style: Theme.of(context).textTheme.button!.copyWith(
                          color: Theme.of(context).scaffoldBackgroundColor),
                    )),
        ),
        onPressed: onPressed);
  }
}
