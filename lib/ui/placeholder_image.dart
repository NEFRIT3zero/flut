// ---------------------------------------------------------------------------
// Placeholder widget shown when the image is missing or corrupt.
// ---------------------------------------------------------------------------
import 'package:flut/ui/my_colors.dart';
import 'package:flutter/material.dart';

class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.inputFill,                       // subtle fill from Auth style
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: MyColors.textHint,
            ),
            const SizedBox(height: 8),
            Text(
              'No image available',
              style: TextStyle(
                color: MyColors.textHint,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
