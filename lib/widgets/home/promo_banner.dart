import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Promotional banner displayed on the Home screen.
///
/// Shows a green CTA banner with a headline, supporting text,
/// and a food image. The image URL can be swapped for a local
/// asset later without changing the widget's public API.
class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  static const String _imageUrl =
      'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=200&fit=crop';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.pagePadding,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          child: Stack(
            children: [
              // ── Text content ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cook the best\nrecipes at home',
                      style: AppTextStyles.headingSmall.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore 1000+ recipes with\ndetailed instructions',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.surface.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Food image ────────────────────────────────────────
              Positioned(
                right: -10,
                bottom: -10,
                child: SizedBox(
                  width: 130,
                  height: 130,
                  child: Opacity(
                    opacity: 0.9,
                    child: Image.network(
                      _imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.restaurant_rounded,
                        size: 60,
                        color: AppColors.surface,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
