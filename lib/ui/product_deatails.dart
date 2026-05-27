import 'package:flut/services/db_controller.dart';
import 'package:flut/models/product.dart';
import 'package:flut/services/providers.dart';
import 'package:flut/ui/my_colors.dart';
import 'package:flut/ui/placeholder_image.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flut/services/user_provider.dart';
import 'package:flut/services/product_provider.dart';

class ProductsDetails extends ConsumerStatefulWidget {
  const ProductsDetails({
    super.key,
    required this.product,
    required this.autoRun,
  });

  final Product product;
  final bool autoRun;
  @override
  ConsumerState<ProductsDetails> createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends ConsumerState<ProductsDetails> {
  @override
  void initState() {
    super.initState();

    // run after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.autoRun) {
       reserve(context, ref, widget.product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productProvider);

    // ref.listen<bool>(autoRunProvider, (previous, next) {
    //   if (next == true) {
    //     // WidgetsBinding.instance.addPostFrameCallback((_) {
    //     //   _buttonLogic(ref);
    //     // });
    //     reserve(context, ref, product);
    //     print('autopress button');
    //     // Reset the flag after consumption to avoid repeated calls
    //     ref.read(autoRunProvider.notifier).state = false;
    //   }
    // });
    // return Scaffold(
    //   appBar: AppBar(),
    //   body: productsAsync.when(
    //     data: (products) {
    //       final currentProduct = products.firstWhere(
    //         (p) => p.qrData == product.qrData,
    //       );

    //       return Column(
    //         children: [
    //           Image.memory(currentProduct.imageBytes, height: 200),

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: MyColors.textLight),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [MyColors.gradientStart, MyColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: productsAsync.when(
                      loading: () => const CircularProgressIndicator(
                        color: MyColors.textLight,
                      ),
                      error: (e, _) => Text(
                        '$e',
                        style: const TextStyle(color: MyColors.errorSnack),
                      ),
                      data: (products) {
                        final currentProduct = products.firstWhere(
                          (p) => p.qrData == widget.product.qrData,
                        );

                        return Card(
                          margin: const EdgeInsets.all(16),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: MyColors.cardBg,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.memory(
                                    currentProduct.imageBytes,
                                    width: double.infinity, // fills card width
                                    fit: BoxFit
                                        .fitWidth, // height adjusts proportionally
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            PlaceholderImage(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentProduct.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.textLight,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      reserve(context, ref, currentProduct);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MyColors.buttonBg,
                                      foregroundColor: MyColors.buttonFg,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: Text(
                                      currentProduct.reservedBy == null
                                          ? 'Забронировать'
                                          : 'Забронировано пользователем ${currentProduct.reservedBy}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.all(8),
                                    child: PrettyQrView.data(
                                      data: widget.product.qrData,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<Product?> getUpdatedProduct() async {
    return await DatabaseController.instance.getProductByQrCode(widget.product.qrData);
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Товар уже забронирован'),
        backgroundColor: MyColors.errorSnack,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
