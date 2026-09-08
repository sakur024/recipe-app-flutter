import 'package:flutter/material.dart';

/// Centralized color palette for the Recipe App.
///
/// All application colors are defined here so they can be adjusted
/// in one place. Semantic names keep usage consistent across the UI.
abstract final class AppColors {
  // ── Primary ──────────────────────────────────────────────────────
  /// Main accent color used for buttons, active elements, and highlights.
  static const Color primary = Color(0xFF1B9C4F);

  /// Lighter tint of the primary color for backgrounds & chips.
  static const Color primaryLight = Color(0xFFE8F5E9);

  // ── Backgrounds & Surfaces ───────────────────────────────────────
  /// Main scaffold / page background.
  static const Color background = Color(0xFFF9FAFB);

  /// Card and elevated surface color.
  static const Color surface = Color(0xFFFFFFFF);

  // ── Text ─────────────────────────────────────────────────────────
  /// Primary text – headings, titles, body copy.
  static const Color textPrimary = Color(0xFF1A1A2E);

  /// Secondary text – captions, hints, supporting info.
  static const Color textSecondary = Color(0xFF6B7280);

  // ── Borders & Dividers ───────────────────────────────────────────
  /// Subtle border / divider color.
  static const Color border = Color(0xFFE5E7EB);

  // ── Semantic / Status ────────────────────────────────────────────
  /// Error & destructive actions.
  static const Color error = Color(0xFFDC2626);

  /// Rating stars, warnings.
  static const Color rating = Color(0xFFF59E0B);
}
