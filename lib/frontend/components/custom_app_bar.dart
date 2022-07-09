import 'package:flutter/material.dart';

import 'toggle_switch_button.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key, this.label = ''}) : super(key: key);
  final String label;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      title:  Text(label,style: Theme.of(context).textTheme.headline3,),
      actions: const [
        ToggleSwitchButton(),
      ],
    );
  }
}
