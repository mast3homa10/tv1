import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer',
      theme: ThemeData(
        primaryColor: Colors.grey.shade800,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final StreamController<int> _controller = StreamController<int>();

  int _seconds = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("title"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          MyTextWidget(stream: _controller.stream), //just update this widget
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: _addPressed,
                iconSize: 150.0,
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () => _controller.add(_seconds++),
                iconSize: 150.0,
              ),
            ],
          )
        ],
      ),
    );
  }

  void _addPressed() {
    //somehow call _updateSeconds()
  }
}

class MyTextWidget extends StatefulWidget {
  final Stream<int> stream;

  const MyTextWidget({required this.stream});

  @override
  _MyTextWidgetState createState() => _MyTextWidgetState();
}

class _MyTextWidgetState extends State<MyTextWidget> {
  int secondsToDisplay = 0;

  void _updateSeconds(int newSeconds) {
    setState(() {
      secondsToDisplay = newSeconds;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.stream.listen((seconds) {
      _updateSeconds(seconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      secondsToDisplay.toString(),
      textScaleFactor: 5.0,
    );
  }
}
