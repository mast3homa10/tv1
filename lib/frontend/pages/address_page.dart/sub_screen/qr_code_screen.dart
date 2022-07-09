import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../frontend/pages/address_page.dart/address_page_controller.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({Key? key, this.boxId = 0}) : super(key: key);
  final int boxId;
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRCodeScreen> {
  Barcode? result;
  QRViewController? qrController;
  final addressConroller = Get.find<AddressPageController>();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController!.pauseCamera();
    }
    qrController!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update qrController
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController qrController) {
    setState(() {
      this.qrController = qrController;
    });
    qrController.scannedDataStream.listen((scanData) async {
      // await Future.delayed(const Duration(seconds: 5));
      try {
        if (scanData.code != null) {
          setState(() {
            if (widget.boxId == 0) {
              addressConroller.textAddressController.text = scanData.code!;
              log('qrcode Result for address = ${addressConroller.textAddressController.text}');
            } else if (widget.boxId == 1) {
              addressConroller.textSupportAddressController.text =
                  scanData.code!;
              log('qrcode Result for support address = ${addressConroller.textSupportAddressController.text}');
            }

            Get.back();
          });
        } else {
          Get.snackbar('توجه!', "آدرس دریافت نشد");
          Get.back();
        }
      } catch (e) {
        Get.snackbar('توجه!', "دریافت آدرس با اسکنر با مشکل مواجه شده");
        Get.back();
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }
}
