import 'package:flut/services/db_controller.dart';
import 'package:flut/models/product.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flut/services/user_provider.dart';
import 'package:flut/services/product_provider.dart';

class ProductsDetails extends ConsumerWidget {
  const ProductsDetails({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productProvider);
    return Scaffold(
      appBar: AppBar(),
      body: productsAsync.when(
        data: (products) {
          final currentProduct = products.firstWhere(
            (p) => p.qrData == product.qrData,
          );

          return Column(
            children: [
              Image.file(File(currentProduct.pathImage), height: 200),

              Text(currentProduct.name),

              ElevatedButton(
                onPressed: () {
                  reserve(context, ref, currentProduct);
                },
                child: Text(
                  currentProduct.reservedBy == null
                      ? 'Забронировать'
                      : 'Забронировано пользователем ${currentProduct.reservedBy}',
                ),
              ),
              SizedBox(height: 16),
              PrettyQrView.data(data: product.qrData),
            ],
          );
        },

        loading: () => CircularProgressIndicator(),

        error: (e, _) => Text('$e'),
      ),
    );
  }

  Future<Product?> getUpdatedProduct() async {
    return await DatabaseController.instance.getProductByQrCode(product.qrData);
  }

  void reserve(BuildContext context, WidgetRef ref, Product product) async {
    final user = ref.watch(userProvider)!;
    final notifier = ref.read(productProvider.notifier);

    if (product.reservedBy == user.login || user.isAdmin) {
      await notifier.unreserveProduct(product);
      return;
    }

    if (product.reservedBy == null) {
      await notifier.reserveProduct(product, user);
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Товар уже забронирован')));
  }
}
