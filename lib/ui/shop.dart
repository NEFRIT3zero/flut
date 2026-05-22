import 'package:flut/ui/create_product.dart';
import 'package:flut/models/product.dart';
import 'package:flut/ui/my_colors.dart';
import 'package:flut/ui/product_cart.dart';
import 'package:flut/ui/product_deatails.dart';
import 'package:flut/scaner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flut/services/product_provider.dart';



// ---------------------------------------------------------------------------
// Custom triangular shape for the FloatingActionButton
// ---------------------------------------------------------------------------
class TriangleBorder extends ShapeBorder {
  const TriangleBorder();

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final double w = rect.width;
    final double h = rect.height;
    // Upward‑pointing triangle: tip at top centre, base at bottom
    return Path()
      ..moveTo(w / 2, 0)   // tip
      ..lineTo(w, h)       // bottom‑right
      ..lineTo(0, h)       // bottom‑left
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // ShapeDecoration & FloatingActionButton handle the painting automatically
  }

  @override
  ShapeBorder scale(double t) => this;
}

// ---------------------------------------------------------------------------
// Shop screen
// ---------------------------------------------------------------------------
class Shop extends ConsumerWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productProvider);

    // Build the AppBar once so we can use its exact toolbar height
    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'Shop',
        style: TextStyle(color: MyColors.textLight),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.qr_code_scanner, color: MyColors.textLight),
          onPressed: () => _openScanner(context),
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: MyColors.textLight),
          onPressed: () => ref.read(productProvider.notifier).refresh(),
        ),
      ],
    );

    // Calculate the exact top padding required:
    // status bar height (from MediaQuery) + toolbar height
    final double topPadding =
        MediaQuery.of(context).padding.top + appBar.preferredSize.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateProduct(context),
        tooltip: 'Add product',
        backgroundColor: MyColors.buttonBg,
        foregroundColor: MyColors.buttonFg,
        shape: const TriangleBorder(),
        elevation: 100,               // ← triangular shape
        child: const Icon(Icons.add),
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
          // Let SafeArea handle bottom & sides, but we manage the top manually
          top: false,
          child: Column(
            children: [
              // Space that exactly matches the AppBar’s full visual height
              SizedBox(height: topPadding),
              Expanded(
                child: productsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: MyColors.textLight,
                    ),
                  ),
                  error: (error, stackTrace) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: MyColors.errorSnack),
                          const SizedBox(height: 16),
                          Text(
                            'Something went wrong',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: MyColors.textLight),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$error',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: MyColors.textLight.withOpacity(0.8)),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => ref.invalidate(productProvider),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.buttonBg,
                              foregroundColor: MyColors.buttonFg,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  data: (products) {
                    if (products.isEmpty) {
                      return Center(
                        child: Text(
                          'No products yet.',
                          style: TextStyle(
                            color: MyColors.textLight.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          onPressed: () =>
                              _openProductDetails(context, product),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- navigation helpers (unchanged) ---
  void _openCreateProduct(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreateProduct()),
    );
  }

  void _openScanner(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ScannerFind()),
    );
  }

  void _openProductDetails(BuildContext context, Product product) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductsDetails(product: product),
      ),
    );
  }
}