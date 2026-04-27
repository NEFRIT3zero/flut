import 'dart:io';

class Product {
  String name;
  String? pathImage;
  File? fileImage;

  Product({required this.name,  this.pathImage, this.fileImage});
}
