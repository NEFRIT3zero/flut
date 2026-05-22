import 'dart:io';
import 'package:flut/models/product.dart';
import 'package:flut/ui/my_colors.dart';
import 'package:flut/ui/placeholder_image.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onPressed,
  });

  final Product product;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 8,                                      // match Auth card elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),         // match Auth card corners
      ),
      color: MyColors.cardBg,                           // same background as Auth card
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _ProductImage(path: product.pathImage),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                product.name,
                style: const TextStyle(
                  color: MyColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal helper widget that safely loads an image from a file path
// and shows a fallback UI if something goes wrong.
// ---------------------------------------------------------------------------
class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final file = File(path);

    // If the file does not exist, show a placeholder immediately
    if (!file.existsSync()) {
      return PlaceholderImage();
    }

    return Image.file(
      file,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => PlaceholderImage(),
    );
  }
}

