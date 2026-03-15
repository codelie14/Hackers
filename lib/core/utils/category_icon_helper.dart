import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/tool_model.dart';

/// Helper class for loading category-specific SVG icons
class CategoryIconHelper {
  CategoryIconHelper._();

  /// Get SVG icon path for a category
  static String getIconPath(ToolCategory category) {
    switch (category) {
      case ToolCategory.crypto:
        return 'assets/icons/categories/crypto.svg';
      case ToolCategory.password:
        return 'assets/icons/categories/password.svg';
      case ToolCategory.encodeDecode:
        return 'assets/icons/categories/encode_decode.svg';
      case ToolCategory.network:
        return 'assets/icons/categories/network.svg';
      case ToolCategory.developer:
        return 'assets/icons/categories/developer.svg';
      case ToolCategory.fileSecurity:
        return 'assets/icons/categories/file_security.svg';
      case ToolCategory.forensics:
        return 'assets/icons/categories/forensics.svg';
      case ToolCategory.wifi:
        return 'assets/icons/categories/wifi.svg';
      // Add more as they are created
      default:
        return ''; // Will fallback to Material Icon
    }
  }

  /// Build SVG icon for category with automatic color
  static Widget buildSvgIcon(
    BuildContext context,
    ToolCategory category, {
    double size = 24,
  }) {
    final iconPath = getIconPath(category);

    if (iconPath.isEmpty) {
      // Fallback to Material Icon
      return Icon(category.icon, size: size, color: category.color);
    }

    return SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(category.color, BlendMode.srcIn),
    );
  }

  /// Check if category has custom SVG icon
  static bool hasCustomIcon(ToolCategory category) {
    final iconPath = getIconPath(category);
    return iconPath.isNotEmpty;
  }
}
