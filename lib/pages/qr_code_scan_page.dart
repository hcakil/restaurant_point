import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:get/get.dart';
import 'package:restaurantpoint/customs/utils/colors.dart';
import 'package:restaurantpoint/pages/main_page.dart';

class QrCodeScanPage extends StatefulWidget {
  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode barcode;
  QRViewController controller;

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(alignment: Alignment.center, children: [
          Container(
            color: Colors.white70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 300,
                    width: 300,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                          cutOutSize: MediaQuery.of(context).size.width * 0.8,
                          borderWidth: 10,
                          borderLength: 20,
                          borderRadius: 10,
                          borderColor: primaryColor),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: buildResult(),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      // buildResult();
    });

    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
      });
    });
  }

  Widget buildResult() {
    if (barcode != null) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        //if(!mounted) return;
        Get.offAll(() => FirstPage(
          gelenAdresId: barcode.code,
          gelenAdresName: "Adres Yorumları",
          isNeed: true,
        ));

      });
    }

    return Text(barcode != null ? "Sonuc ${barcode.code}" : "QR Tara");
  }
}
