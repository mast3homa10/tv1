import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: AnimatedSwapWidget(),
        ),
      ),
    );
  }
}

class AnimatedSwapWidget extends StatefulWidget {
  const AnimatedSwapWidget({Key? key}) : super(key: key);

  @override
  createState() => _AnimatedSwapWidgetState();
}

class _AnimatedSwapWidgetState extends State<AnimatedSwapWidget>
    with TickerProviderStateMixin {
  final double widgetATop = 0;
  final double widgetBTop = 200;
  bool swapped = false;

  late AnimationController controller;
  late Animation<double> addressAnimation;
  animationListener() => setState(() {});

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // Initialize animations
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    addressAnimation = Tween(
      begin: 0.0,
      end: widgetBTop - widgetATop,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ))
      ..addListener(animationListener);
  }

  @override
  dispose() {
    // Dispose of animation controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tweenValue = addressAnimation.value;

    return SizedBox(
      width: 300,
      height: 150,
      child: Stack(
        children: <Widget>[
          //Widget A
          Positioned(
            top: widgetATop + tweenValue,
            left: 20,
            child: const Text("This is widget A"),
          ),
          // Widget B
          Positioned(
            top: widgetBTop - tweenValue,
            left: 20,
            child: const Text("This is widget B"),
          ),
          // Swap button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () => setState(() {
                swapped ? controller.reverse() : controller.forward();
                swapped = !swapped;
              }),
              child: const Text("swap"),
            ),
          ),
        ],
      ),
    );
  }
}
