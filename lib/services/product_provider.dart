import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod/legacy.dart';
import 'package:flut/services/db_controller.dart';
import 'package:flut/models/product.dart';
import 'package:flut/models/user.dart';

final productProvider = AsyncNotifierProvider<ProductNotifier, List<Product>>(
  ProductNotifier.new,
);

class ProductNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    return await DatabaseController.instance.getProducts();
  }

  Future<void> addProduct(Product product) async {
    await DatabaseController.instance.insertProduct(product);

    final products = await DatabaseController.instance.getProducts();

    state = AsyncData(products);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    final products = await DatabaseController.instance.getProducts();

    state = AsyncData(products);
  }
  // Future<Product?> getByQr(String qr) async {
  //   return await db.getProductByQrCode(qr);
  // }

  Future<void> reserveProduct(Product product, User user) async {
    await DatabaseController.instance.reserveProduct(product, user);

    final products = await DatabaseController.instance.getProducts();

    state = AsyncData(products);
  }

  Future<void> unreserveProduct(Product product) async {
    await DatabaseController.instance.unreserveProduct(product);

    final products = await DatabaseController.instance.getProducts();

    state = AsyncData(products);
  }
}
