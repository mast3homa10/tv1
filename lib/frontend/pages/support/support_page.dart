import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../frontend/components/custom_big_button.dart';
import '../../../frontend/components/toggle_switch_button.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomBigButton(
                label: 'ارتباط با ما',
                onPressed: () {
                  Get.to(const ChatPage());
                }),
          ))
        ],
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  final textController = TextEditingController();
  late AnimationController _controller;
  late Animation _animation;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation =
        Tween(begin: Get.height * 0.75, end: 220.0).animate(_controller)
          ..addListener(() {
            setState(() {});
          });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: const SizedBox(
            height: 40,
            width: 40,
            child: AspectRatio(
              aspectRatio: 1 / 0.5,
              child: Image(
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
          ),
          actions: const [
            ToggleSwitchButton(),
          ],
        ),
        body: Column(
          children: [
            Center(
              child: Text(
                'در حال توسعه ...',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            SizedBox(height: _animation.value),
            buildCaht(
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCaht(
    BuildContext context,
  ) =>
      Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          // color: Theme.of(context).appBarTheme.backgroundColor,
        ),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child:
                    IconButton(onPressed: () {}, icon: const Icon(Icons.send))),
            Expanded(
              flex: 4,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: TextFormField(
                  controller: textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(hintText: 'dsafsa'),
                  focusNode: _focusNode,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.paperclip)),
            ),
          ],
        ),
      );
}
