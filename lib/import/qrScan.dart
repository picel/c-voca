import 'package:CVoca/import/scanResult.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        allowDuplicates: false,
        controller: MobileScannerController(
          facing: CameraFacing.back,
        ),
        onDetect: (barcode, args) async {
          var barcodeValue;
          if (barcode.rawValue == null) {
            debugPrint('No barcode detected');
          } else {
            barcodeValue = barcode.rawValue!;
            debugPrint('Barcode detected: $barcodeValue');
          }
          //turn off camera
          MobileScannerController().stop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScanResult(
                scanResult: barcodeValue,
              ),
            ),
          );
        },
      ),
    );
  }
}
