// import 'dart:io';



import 'dart:convert';
import 'dart:typed_data';

class Product {
  String name;
  Uint8List imageBytes;
  String qrData;
  String? reservedBy;

  Product({
    required this.qrData, 
    required this.name, 
    required this.imageBytes, 
    this.reservedBy
  });

  Map<String, dynamic> toMap() {
    return {
      'qrData': qrData,
      'name': name,
      'imageBytes': base64Encode(imageBytes),
      'reservedBy': reservedBy,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      qrData: map['qrData'],
      name: map['name'],
      imageBytes: base64Decode(map['imageBytes']),
      reservedBy: map['reservedBy'],
    );
  }
}




