import 'package:flut/ui/shop.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'ui/product_deatails.dart';
import 'services/db_controller.dart';
import 'models/product.dart';


  
class ScannerFind extends StatefulWidget { 
  const ScannerFind({super.key});

  @override
  State<ScannerFind> createState() => _ScannerFindState();
}   

// class _ScannerFindState extends State<ScannerFind> {
//   final MobileScannerController controller = MobileScannerController();
//   bool isScanning = true;

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return MobileScanner(
//       controller: controller,
//       onDetect: (capture) {
//         String value = capture.barcodes.first.rawValue!;
//         print('Scanned: $value');
//         checkProduct(value, context);
//       },
//     );
//   }
// }
  

  void checkProduct(String result,BuildContext context) async {
    Product? product = await DatabaseController().getProductByQrCode(result);
    if (product != null){
      Navigator.push(context,MaterialPageRoute(
      builder: (context) => ProductsDetails(product: product)));
    }else{
      ScaffoldMessenger.of(
      context,
      ).showSnackBar(SnackBar(content: Text('Нет такого qr кода')));
      print(result);
    }

  }


class _ScannerFindState extends State<ScannerFind> {
    final MobileScannerController controller = MobileScannerController();
    bool _isScanning = true;

    @override
    void dispose() {
        controller.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Сканировать QR")
            ),
            body: Stack(
                children: [
                    MobileScanner(
                        controller: controller,
                        onDetect: (capture) {
                            if (!_isScanning) return;
                            final List<Barcode> barcodes = capture.barcodes;
                            for (final barcode in barcodes) {
                                if (barcode.rawValue != null) {
                                    _isScanning = false;
                                    Navigator.of(context).pop();
                                    checkProduct(barcode.rawValue!, context);
                                    return;
                                }
                            }
                        },
                        
                    ),

                    Center(
                        child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.green,
                                    width: 3,
                                ),
                                borderRadius: BorderRadius.circular(12),
                            ),
                        ),
                    ),

                    Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: Center(
                            child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                
                                child: Text(
                                    "Отмена",
                                    
                                ),
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}

// class ScannerErrorWidget extends StatelessWidget {
//     final MobileScannerException error;
//     final VoidCallback onBack;

//     const ScannerErrorWidget({
//         super.key,
//         required this.error,
//         required this.onBack,
//     });

//     @override
//     Widget build(BuildContext context) {
//         String message = 'Не удалось запустить камеру.';
//         if (error.errorCode == MobileScannerErrorCode.cameraNotAvailable) {
//             message = 'Камера недоступна на этом устройстве.';
//         } else if (error.errorCode == MobileScannerErrorCode.permissionDenied) {
//             message = 'Нет разрешения на использование камеры.';
        // }