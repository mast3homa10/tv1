import 'package:flutter/material.dart';
import 'package:tv1/constants.dart';

class LoaderPage extends StatelessWidget {
  const LoaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: kSpinkit),
    );
  }
}
