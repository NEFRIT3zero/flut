import 'package:flutter/material.dart';

class MyColors {
  // Green gradient (unchanged)
  static const Color gradientStart = Color(0xFF1B5E20); // dark green
  static const Color gradientEnd   = Color(0xFF4CAF50); // medium green

  // Text & icons on dark backgrounds
  static const Color textLight = Colors.white;

  // Dark surfaces
  static const Color cardBg    = Color(0xFF1E1E1E);
  static const Color inputFill = Color(0xFF2C2C2C);

  // Buttons
  static const Color buttonBg  = Color(0xFF2E7D32);
  static const Color buttonFg  = Colors.white;

  // Hints & secondary text
  static const Color textHint  = Colors.grey;

  // Snackbar
  static const Color errorSnack = Color(0xFFC62828);

  // NEW: focused border colour
  static const Color focusedBorder = Color(0xFF66BB6A); // light green
}