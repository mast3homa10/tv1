import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';

class SwapButton extends StatelessWidget {
  const SwapButton({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor ??
                kLightChangerColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Theme.of(context).dividerTheme.color ??
                  const Color(0xFFEEEEEE),
              style: BorderStyle.solid,
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                FontAwesomeIcons.arrowUp,
                size: 20,
              ),
              Icon(
                FontAwesomeIcons.arrowDown,
                size: 20,
              ),
            ],
          ),
        ));
  }
}
