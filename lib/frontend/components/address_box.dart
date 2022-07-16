import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:clipboard/clipboard.dart';

import '../../frontend/pages/address/address_page_controller.dart';
import '../pages/address/sub_screen/qr_code_screen.dart';
import '../pages/exchange/exchange_page_controller.dart';

class AddressBox extends StatefulWidget {
  final String hintText;
  final Color activeColor;
  final int boxId;
  final TextEditingController textController;
  final bool isActive;
  const AddressBox({
    Key? key,
    this.boxId = 0,
    this.hintText = '',
    this.activeColor = Colors.green,
    this.isActive = false,
    required this.textController,
  }) : super(key: key);
  const AddressBox.support({
    Key? key,
    this.boxId = 1,
    this.hintText = '',
    this.activeColor = Colors.green,
    this.isActive = false,
    required this.textController,
  }) : super(key: key);

  @override
  State<AddressBox> createState() => _AddressBoxState();
}

class _AddressBoxState extends State<AddressBox> {
  final exchangeController = Get.find<ExchangePageController>();
  final addressController = Get.find<AddressPageController>();

  String pasteValue = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isActive
              ? widget.activeColor
              : Theme.of(context).dividerTheme.color ?? const Color(0xFFEEEEEE),
          style: BorderStyle.solid,
          width: 2.0,
        ),
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // paset button
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)))),
                    child: Text(
                      "چسباندن",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontFamily: "Yekabakh",
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                    onPressed: () {
                      FlutterClipboard.paste().then((value) {
                        // Do what ever you want with the value.
                        setState(() {
                          widget.textController.text = value;
                          pasteValue = value;
                        });
                      });
                    },
                  ),
                  const VerticalDivider(
                    color: Color(0xFFFFFFFF),
                    indent: 9,
                    endIndent: 9,
                  ),
                ],
              ),
            ),

            // input for address
            Expanded(
              flex: 6,
              child: TextFormField(
                controller: widget.textController,
                toolbarOptions: const ToolbarOptions(
                    copy: false, paste: false, cut: false, selectAll: false),
                style: Theme.of(context).textTheme.headline4,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).appBarTheme.backgroundColor ??
                            Colors.greenAccent,
                        width: 0.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).appBarTheme.backgroundColor ??
                            Colors.red,
                        width: 5.0),
                  ),
                  hintMaxLines: 3,
                  hintText: widget.hintText,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Theme.of(context).dividerTheme.color),
                ),
              ),
            ),
            // scan qrcode icon
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(FontAwesomeIcons.qrcode),
                onPressed: () {
                  Get.to(() => QRCodeScreen(
                        boxId: widget.boxId,
                      ));
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
