import 'package:flutter/material.dart';

/// Static class to store the primary color scheme of the application.
/// Use these constants to ensure consistent colors throughout the app.
class AppColors {
  /// The primary background color (canvas).
  /// Typically used for the scaffold or main container.
  static const Color primary = Color(0xFFFCFCFC);

  /// A slightly darker background color than [primary].
  /// Used for general page backgrounds.
  static const Color background = Color(0xFFF9F9F9);

  /// A vibrant accent color (tertiary).
  /// Used for primary buttons, emphasized icons, or important interactive elements.
  static const Color tertiary = Color(0xFF22ACDD);

  /// A secondary color for text, selected buttons, and other key elements.
  /// Provides good contrast against [primary] and [background].
  static const Color secondary = Color(0xFF343A40);

  /// A color for disabled elements.
  /// Typically used for inactive buttons or text.
  static const Color disabled = Color(0xFFD9D9D9);

  /// A color for components within the SearchBar.
  static const Color searchBarComponents = Color(0xFF79747E);

  static const Color weatherBox = Color(0xFFF4F4F4);
}
