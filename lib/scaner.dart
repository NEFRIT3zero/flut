import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerFind extends StatelessWidget {
  const ScannerFind({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      onDetect: (result){
        print(result.barcodes.first.rawValue);
      },
    );
  }
}