import 'dart:io';
import 'package:flut/models/product.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class ProductCart extends StatelessWidget {
  const ProductCart({
    super.key,
    required this.product,
    required this.onPressed,
  });

  final Product product;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: onPressed,  
      child: Column(
          children: [
            Image.memory(product.imageBytes, height: 200), 
            Text(product.name)
          ],
        ),
    );
  }
}
