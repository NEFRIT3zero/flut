import 'package:flut/ui/create_product.dart';
import 'package:flut/models/product.dart';
import 'package:flut/ui/my_colors.dart';
import 'package:flut/ui/product_cart.dart';
import 'package:flut/ui/product_deatails.dart';
import 'package:flut/scaner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flut/services/product_provider.dart';

import 'dart:math' as math;

class TriangleBorder extends ShapeBorder {
  final double borderRadius;

  const TriangleBorder({this.borderRadius = 0.0});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final double w = rect.width;
    final double h = w * math.sqrt(3) / 2;

    // Place the triangle so its centroid is at the centre of the FAB's rect
    final double cx = rect.center.dx;
    final double cy = rect.center.dy;
    final double tipY = cy - 2 * h / 3; // centroid is 2h/3 below tip
    final double bottomY = tipY + h;

    final Offset v0 = Offset(cx, tipY); // top
    final Offset v1 = Offset(rect.right, bottomY); // bottom-right
    final Offset v2 = Offset(rect.left, bottomY); // bottom-left

    // Sharp triangle when borderRadius <= 0
    if (borderRadius <= 0.0) {
      return Path()
        ..moveTo(v0.dx, v0.dy)
        ..lineTo(v1.dx, v1.dy)
        ..lineTo(v2.dx, v2.dy)
        ..close();
    }

    // Rounded triangle
    final double r = math.min(borderRadius, h / 3); // max radius = inradius
    final double d = r * math.sqrt(3); // tangent distance along edges

    final List<Offset> vertices = [v0, v1, v2];

    // Tangent points on the edges near each vertex
    Offset tangentIn(int i) {
      final Offset prev = vertices[(i - 1 + 3) % 3];
      final Offset curr = vertices[i];
      final Offset dir = (prev - curr);
      final double len = dir.distance;
      return len == 0 ? curr : curr + (dir / len) * d;
    }

    Offset tangentOut(int i) {
      final Offset next = vertices[(i + 1) % 3];
      final Offset curr = vertices[i];
      final Offset dir = (next - curr);
      final double len = dir.distance;
      return len == 0 ? curr : curr + (dir / len) * d;
    }

    final Offset pt_in0 = tangentIn(0);
    final Offset pt_out0 = tangentOut(0);
    final Offset pt_in1 = tangentIn(1);
    final Offset pt_out1 = tangentOut(1);
    final Offset pt_in2 = tangentIn(2);
    final Offset pt_out2 = tangentOut(2);

    final Path path = Path()
      ..moveTo(pt_in0.dx, pt_in0.dy)
      // Arc around top vertex
      ..conicTo(v0.dx, v0.dy, pt_out0.dx, pt_out0.dy, 0.5)
      ..lineTo(pt_in1.dx, pt_in1.dy)
      // Arc around bottom-right vertex
      ..conicTo(v1.dx, v1.dy, pt_out1.dx, pt_out1.dy, 0.5)
      ..lineTo(pt_in2.dx, pt_in2.dy)
      // Arc around bottom-left vertex
      ..conicTo(v2.dx, v2.dy, pt_out2.dx, pt_out2.dy, 0.5)
      ..close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

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
      title: const Text('Shop', style: TextStyle(color: MyColors.textLight)),
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
        shape: const TriangleBorder(borderRadius: 8.0), // rounded corners
        elevation: 100,
        child: const Icon(Icons.add, color: Color.fromARGB(255, 0, 255, 0)), // centred automatically
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
                    child: CircularProgressIndicator(color: MyColors.textLight),
                  ),
                  error: (error, stackTrace) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: MyColors.errorSnack,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Something went wrong',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(color: MyColors.textLight),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$error',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: MyColors.textLight.withOpacity(0.8),
                                ),
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
                    return RefreshIndicator(
                      onRefresh: () async {
                        await ref.read(productProvider.notifier).refresh();
                      },
                      child: products.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    return SizedBox(
                                      height: constraints.maxHeight,
                                      child: Center(
                                        child: Text(
                                          'No products yet.',
                                          style: TextStyle(
                                            color: MyColors.textLight.withOpacity(0.8),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          : ListView.builder(
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
                            ),
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
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CreateProduct()));
  }

  void _openScanner(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ScannerFind()));
  }

  void _openProductDetails(BuildContext context, Product product) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductsDetails(product: product)),
    );
  }
}
