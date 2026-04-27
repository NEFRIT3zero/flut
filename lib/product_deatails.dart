import 'package:flut/product.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ProductsDetails extends StatelessWidget {
  const ProductsDetails({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Container(
            alignment: Alignment(0.0, 0.0),
            child:Column(
              children: [
                product.fileImage != null? Image.file(product.fileImage!): Image.asset(product.pathImage!), 
                Text(product.name),
                PrettyQrView.data(
                  data: product.name+product.hashCode.toString(),
                  decoration: const PrettyQrDecoration(
                    image: PrettyQrDecorationImage(
                      image: AssetImage('images/flutter.png'),
                    ),
                    quietZone: PrettyQrQuietZone.standart,
                  ),
                )],
            ),
          )
        ]
      
      )

    );
  }
}
