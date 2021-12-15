import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeGeneratePage extends StatefulWidget {
  QRCodeGeneratePage({Key key, this.gelenAdresId, this.gelenAdresName})
      : super(key: key);
  String gelenAdresId;

  String gelenAdresName;

  @override
  _QRCodeGeneratePageState createState() => _QRCodeGeneratePageState();
}

class _QRCodeGeneratePageState extends State<QRCodeGeneratePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QrImage(
            data: widget.gelenAdresId,
            size: 300,
            backgroundColor: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              widget.gelenAdresName,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.purple,
                  letterSpacing: 2,
                  fontFamily: "Lobster"),
            ),
          ),
        ],
      ),
    );
  }
}
