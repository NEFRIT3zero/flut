import 'package:flut/create_product.dart';
import 'package:flut/product.dart';
import 'package:flut/product_cart.dart';
import 'package:flut/product_deatails.dart';
import 'package:flut/scaner.dart';
import 'package:flutter/material.dart';

List<Product> products = [
  Product(name: 'p1', pathImage: 'assets/img/neco_jesus.png'),
  Product(name: 'p2', pathImage: 'assets/img/YK_ZnmFMQdw.jpg'),
  Product(name: 'p3', pathImage: 'assets/img/tea.png'),
];

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Склад'),
        leading: ElevatedButton(onPressed: onPressed, child: const Icon(Icons.add)),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          // crossAxisCount: 2,
          maxCrossAxisExtent: 220,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.9
        ),
        
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCart(
            product: products[index],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductsDetails(product: products[index]),
                ),
              );
            },
          );
        },

        ),
      // ListView.builder(
      //   itemCount: products.length,
      //   itemBuilder: (context, index) {
      //     return ProductCart(
      //       product: products[index],
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) =>
      //                 ProductsDetails(product: products[index]),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void onPressed() async{
    var newProduct = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateProduct()));
    if (newProduct != null){
      setState(() {
        products.add(newProduct);
      });
    }
  }
  void onPressedTwo() async{
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScannerFind()));
    
  }
}
