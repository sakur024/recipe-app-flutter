import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Centralized text styles for the Recipe App.
///
/// Every text style references [AppColors] so colours stay in sync
/// with the palette. Font sizes follow a modest typographic scale.
abstract final class AppTextStyles {
  // ── Headings ─────────────────────────────────────────────────────

  /// Large page heading (e.g. "Good Morning").
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Section heading (e.g. "Popular Recipes").
  static const TextStyle headingMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Small heading / card title.
  static const TextStyle headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ── Body ─────────────────────────────────────────────────────────

  /// Standard body text.
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Slightly smaller body text.
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // ── Secondary / Supporting ───────────────────────────────────────

  /// Secondary supporting text (captions, metadata).
  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// Small label (tags, chips, timestamps).
  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ── Buttons ──────────────────────────────────────────────────────

  /// Primary button text.
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
}
