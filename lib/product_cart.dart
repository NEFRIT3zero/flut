import 'package:flut/product.dart';
import 'package:flutter/material.dart';

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
      child: Column(//container
          children: [product.fileImage != null
          ? Image.file(product.fileImage!, height: 200,)
          : Image.asset(product.pathImage!, height: 200,), Text(product.name)],
        ),
      
    );
  }
}
