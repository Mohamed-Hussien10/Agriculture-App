import 'package:flutter/material.dart';

import '../helpers/extensions.dart';

class AppColors {
  AppColors._();

  // Primary colors
  static final Color primary = HexColor.fromHex(
    '#2563EB',
  ); // Vibrant blue (modern professional)
  static final Color primaryDark = HexColor.fromHex('#1E40AF'); // Darker blue
  static final Color primaryLight = HexColor.fromHex('#3B82F6'); // Lighter blue

  // Secondary colors
  static final Color secondary = HexColor.fromHex('#7C3AED'); // Modern purple
  static final Color secondaryDark = HexColor.fromHex('#5B21B6');
  static final Color secondaryLight = HexColor.fromHex('#8B5CF6');

  // Accent colors
  static final Color accent = HexColor.fromHex('#06B6D4'); // Teal accent
  static final Color success = HexColor.fromHex('#10B981'); // Emerald green
  static final Color warning = HexColor.fromHex('#F59E0B'); // Amber
  static final Color error = HexColor.fromHex('#EF4444'); // Modern red

  // Neutral colors
  static final Color background = HexColor.fromHex(
    '#F8FAFC',
  ); // Very light grey
  static final Color surface = HexColor.fromHex('#FFFFFF'); // Pure white
  static final Color card = HexColor.fromHex('#FFFFFF'); // Card background

  // Text colors
  static final Color textPrimary = HexColor.fromHex('#0F172A'); // Almost black
  static final Color textSecondary = HexColor.fromHex('#334155'); // Dark grey
  static final Color textTertiary = HexColor.fromHex('#64748B'); // Medium grey
  static final Color textDisabled = HexColor.fromHex('#94A3B8'); // Light grey

  // Border and divider colors
  static final Color border = HexColor.fromHex('#E2E8F0'); // Very light grey
  static final Color divider = HexColor.fromHex(
    '#F1F5F9',
  ); // Slightly darker than background

  // State colors
  static final Color hover = HexColor.fromHex('#F1F5F9').withOpacity(0.8);
  static final Color focus = HexColor.fromHex('#DBEAFE');
  static final Color highlight = HexColor.fromHex('#EFF6FF');
  static final Color splash = HexColor.fromHex('#DBEAFE').withOpacity(0.6);

  // Dark mode colors (optional)
  static final Color darkBackground = HexColor.fromHex('#0F172A');
  static final Color darkSurface = HexColor.fromHex('#1E293B');
  static final Color darkTextPrimary = HexColor.fromHex('#F8FAFC');
  static final Color darkTextSecondary = HexColor.fromHex('#E2E8F0');

  static var white = HexColor.fromHex('#FFFFFF');
  static var black = HexColor.fromHex('#000000');

  // New Material Design 3 colors
  static const Color primaryContainer = Color(
    0xFFD0E4FF,
  ); // Light blue for containers
  static const Color onPrimaryContainer = Color(
    0xFF001D35,
  ); // Dark text/icon on primaryContainer

  static const Color maleBlue = Color(0xFF2196F3); // Blue color for male
  static const Color femalePink = Color(0xFFE91E63); // Pink color for female

  static const Color surfaceVariant = Color(
    0xFFE7E0EC,
  ); // Or any color you prefer
}
