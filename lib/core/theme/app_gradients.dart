import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  AppGradients._();

  // Primary accent gradient
  static const LinearGradient accent = LinearGradient(
    colors: [Color(0xFF00FF88), Color(0xFF00CC66)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Category gradients
  static const LinearGradient crypto = LinearGradient(
    colors: [Color(0xFF00FF88), Color(0xFF44FFAA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient password = LinearGradient(
    colors: [Color(0xFF4488FF), Color(0xFF66AAFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient encode = LinearGradient(
    colors: [Color(0xFFFFAA00), Color(0xFFFFCC44)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient network = LinearGradient(
    colors: [Color(0xFF44DDFF), Color(0xFF66EEFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient developer = LinearGradient(
    colors: [Color(0xFFCC88FF), Color(0xFFDD99FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background gradients
  static const LinearGradient cardBackground = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF141414)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient surfaceBackground = LinearGradient(
    colors: [Color(0xFF111111), Color(0xFF0D0D0D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Neon glow effect (for shadows)
  static BoxShadow neonGlow({
    Color? color,
    double blurRadius = 20,
    double spreadRadius = 5,
  }) {
    return BoxShadow(
      color: color ?? AppColors.accent.withValues(alpha: 0.5),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
    );
  }

  // Glassmorphism effect
  static BoxDecoration glassmorphism({
    Color? color,
    double blurSigma = 10,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.bgElevated.withValues(alpha: 0.7),
      border: Border.all(
        color: AppColors.border.withValues(alpha: 0.3),
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }

  // Get gradient by category
  static LinearGradient getCategoryGradient(String category) {
    switch (category.toLowerCase()) {
      case 'crypto':
        return crypto;
      case 'password':
        return password;
      case 'encode':
      case 'encoding':
        return encode;
      case 'network':
        return network;
      case 'developer':
        return developer;
      default:
        return accent;
    }
  }
}
