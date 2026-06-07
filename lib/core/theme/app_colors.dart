import 'package:flutter/material.dart';

/// Centralized color tokens (semantic naming) based on the official palette
class AppColors {
  // Official palette
  static const primary = Color(0xFF4285F4); // Azure Blue
  static const primaryDark = Color(0xFF1A73E8); // Deep Azure Blue
  static const secondary = Color(0xFFE8F0FE); // Soft Sky (secondary background)
  static const accent = Color(0xFFFBBC04); // Sunburst Yellow
  static const background = Color(0xFFF7F9FC); // Clean White
  static const surface = Color(0xFFF7F9FC); // use same clean white for surfaces
  static const surfaceVariant = Color(0xFFF0F4FA);
  static const textPrimary = Color(0xFF1A1C1E); // Midnight Navy

  // Result screen accents
  static const headerTint = Color(0xFFF8FAFF);
  static const scorePill = Color(0xFFDBE2F9);
  static const statCard = Color(0xFFF1F3FA);
  static const textNavy = Color(0xFF001B3D);
  static const textNavyMuted = Color(0xFF111A37);
  static const successTint = Color(0xFFDFF6E6);

  // Derived / neutral tokens (use palette base with opacity where needed)
  static const textSecondary = Color(0x991A1C1E); // 60% Midnight Navy
  static const textOnPrimary = Color(0xFFF7F9FC); // Clean White on primary
  static const border = Color(0x1A1A1C1E); // 10% Midnight Navy for outlines
  static const disabled = Color(0x4D1A1C1E); // 30% Midnight Navy for disabled

  // Fallbacks for semantic feedback (kept neutral to palette)
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFEF5350);
}
