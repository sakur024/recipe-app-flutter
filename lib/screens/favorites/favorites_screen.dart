import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/recipe.dart';
import '../../providers/favorites_provider.dart';
import '../recipe_details/recipe_details_screen.dart';

/// Screen showing the user's favorited recipes.
///
/// Listens to [FavoritesProvider] to keep the list in sync when
/// recipes are favorited/unfavorited from other screens.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final favorites = favoritesProvider.favorites;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title bar ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.pagePadding,
              16,
              AppConstants.pagePadding,
              16,
            ),
            child: Text('Favorites', style: AppTextStyles.headingLarge),
          ),

          // ── Content ────────────────────────────────────────
          Expanded(
            child: favorites.isEmpty
                ? const _EmptyState()
                : _FavoriteList(recipes: favorites),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
// Private sub-widgets
// ═════════════════════════════════════════════════════════════════════

/// Shown when the user has no favorites.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_outline_rounded,
            size: 72,
            color: AppColors.border,
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart icon on any recipe\nto save it here.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }
}

/// Scrollable list of favorited recipe cards.
class _FavoriteList extends StatelessWidget {
  const _FavoriteList({required this.recipes});

  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.pagePadding,
        vertical: 4,
      ),
      itemCount: recipes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return _FavoriteCard(
          recipe: recipe,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => RecipeDetailsScreen(recipe: recipe),
              ),
            );
          },
          onRemove: () {
            context.read<FavoritesProvider>().removeFavorite(recipe);
          },
        );
      },
    );
  }
}

/// A horizontal card for a single favorite recipe.
class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({
    required this.recipe,
    required this.onTap,
    required this.onRemove,
  });

  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            // ── Image ────────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppConstants.borderRadiusLarge),
              ),
              child: Image.network(
                recipe.imageUrl,
                height: 110,
                width: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 110,
                  width: 110,
                  color: AppColors.primaryLight,
                  child: const Icon(
                    Icons.restaurant_rounded,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            // ── Details ──────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${recipe.calories} cal · ${recipe.timeMinutes} min',
                      style: AppTextStyles.label,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppColors.rating,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe.rating.toStringAsFixed(1),
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${recipe.reviewCount})',
                          style: AppTextStyles.label,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Heart button ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: onRemove,
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.error,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
