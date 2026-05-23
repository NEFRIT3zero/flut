import 'package:flut/ui/create_product.dart';
import 'package:flut/models/product.dart';
import 'package:flut/ui/product_cart.dart';
import 'package:flut/ui/product_deatails.dart';
import 'package:flut/scaner.dart';
import 'package:flutter/material.dart';
import 'package:flut/services/db_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:riverpod/riverpod.dart';
import 'package:flut/services/product_provider.dart';

// List<Product> products = [
//   Product(name: 'p1', pathImage: 'assets/img/neco_jesus.png', qrData: 'p1werwerw'),
//   Product(name: 'p2', pathImage: 'assets/img/YK_ZnmFMQdw.jpg', qrData: 'p2werwerw'),
//   Product(name: 'p3', pathImage: 'assets/img/tea.png', qrData: 'p3werwerw'),
// ];

class Shop extends ConsumerWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productProvider);
    

    return productsAsync.when(
      loading: () => const CircularProgressIndicator(),

      error: (e, _) => Text('$e'),

      data: (products) {
        return Scaffold(
          appBar: AppBar(),
          body: ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, i) {
              return ProductCart(
                product: products[i],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductsDetails(product: products[i]),
                    ),
                  );
                },
              );
            },
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              onPressed(context);
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void onPressed(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => CreateProduct()));
  }

  void onPressedTwo(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => ScannerFind()));
  }

  void onPressedCart(BuildContext context, Product product) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductsDetails(product: product),
      ),
    );
  }

  // Future<void> loadItems() async {
  //   setState(() { isLoading = true; });
  //   List<Product> _products = await DatabaseController().getProducts();
  //   setState(() {
  //     products = _products;
  //     isLoading=false;
  //     print('loadet');
  //     print(products[0].name);
  //   });
  // }
}
