// import 'dart:io';



class Product {
  String name;
  String pathImage;
  String qrData;
  String? reservedBy;

  Product({
    required this.qrData, 
    required this.name, 
    required this.pathImage, 
    this.reservedBy
  });

  Map<String, dynamic> toMap() {
    return {
      'qrData': qrData,
      'name': name,
      'pathImage': pathImage,
      'reservedBy': reservedBy,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      qrData: map['qrData'],
      name: map['name'],
      pathImage: map['pathImage'],
      reservedBy: map['reservedBy'],
    );
  }
}




