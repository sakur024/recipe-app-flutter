import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/recipe.dart';
import '../../providers/favorites_provider.dart';

/// Full-screen recipe details shown when a recipe card is tapped.
///
/// Receives a [Recipe] object. Displays the image, metadata, rating,
/// ingredients (with serving selector), and a "Start Cooking" CTA.
/// Serving count is local state; favorite state is managed via [FavoritesProvider].
class RecipeDetailsScreen extends StatefulWidget {
  const RecipeDetailsScreen({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  late int _servings;

  Recipe get _recipe => widget.recipe;

  @override
  void initState() {
    super.initState();
    _servings = _recipe.defaultServings;
  }

  // ── Helpers ──────────────────────────────────────────────────────

  void _incrementServings() => setState(() => _servings++);

  void _decrementServings() {
    if (_servings > 1) setState(() => _servings--);
  }

  void _toggleFavorite() {
    context.read<FavoritesProvider>().toggleFavorite(_recipe);
  }

  // ── Build ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<FavoritesProvider>().isFavorite(_recipe);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroImage(
                    imageUrl: _recipe.imageUrl,
                    isFavorite: isFavorite,
                    onBack: () => Navigator.of(context).pop(),
                    onFavorite: _toggleFavorite,
                  ),
                  const SizedBox(height: 20),
                  _TitleSection(recipe: _recipe),
                  const SizedBox(height: 16),
                  _MetadataRow(recipe: _recipe),
                  const SizedBox(height: 24),
                  _IngredientsSection(
                    recipe: _recipe,
                    servings: _servings,
                    onIncrement: _incrementServings,
                    onDecrement: _decrementServings,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Fixed bottom CTA
          _StartCookingButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cooking mode coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
// Private sub-widgets
// ═════════════════════════════════════════════════════════════════════

/// Large hero image with overlaid back and favorite buttons.
class _HeroImage extends StatelessWidget {
  const _HeroImage({
    required this.imageUrl,
    required this.isFavorite,
    required this.onBack,
    required this.onFavorite,
  });

  final String imageUrl;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        // ── Image ────────────────────────────────────────────────
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
          child: Image.network(
            imageUrl,
            height: 320,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 320,
              color: AppColors.primaryLight,
              child: const Center(
                child: Icon(
                  Icons.restaurant_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),

        // ── Top bar ──────────────────────────────────────────────
        Positioned(
          top: topPadding + 8,
          left: 12,
          right: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CircleButton(
                icon: Icons.arrow_back_rounded,
                onTap: onBack,
              ),
              _CircleButton(
                icon: isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconColor: isFavorite ? AppColors.error : null,
                onTap: onFavorite,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Semi-transparent circular icon button used on top of the hero image.
class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22, color: iconColor ?? AppColors.textPrimary),
      ),
    );
  }
}

/// Recipe title and rating row.
class _TitleSection extends StatelessWidget {
  const _TitleSection({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(recipe.name, style: AppTextStyles.headingMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 20, color: AppColors.rating),
              const SizedBox(width: 4),
              Text(
                recipe.rating.toStringAsFixed(1),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${recipe.reviewCount} reviews)',
                style: AppTextStyles.bodySecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Horizontal metadata chips (calories, time, category).
class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.pagePadding),
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        children: [
          _MetadataChip(
            icon: Icons.local_fire_department_rounded,
            label: '${recipe.calories} cal',
          ),
          _MetadataChip(
            icon: Icons.timer_outlined,
            label: '${recipe.timeMinutes} min',
          ),
          _MetadataChip(
            icon: Icons.category_outlined,
            label: recipe.category,
          ),
        ],
      ),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  const _MetadataChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.label.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// Ingredients list with a serving selector.
class _IngredientsSection extends StatelessWidget {
  const _IngredientsSection({
    required this.recipe,
    required this.servings,
    required this.onIncrement,
    required this.onDecrement,
  });

  final Recipe recipe;
  final int servings;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header + serving selector ───────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ingredients', style: AppTextStyles.headingSmall),
              _ServingSelector(
                servings: servings,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${recipe.ingredients.length} items',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 16),

          // ── Ingredient list ─────────────────────────────────────
          ...recipe.ingredients.map(
            (ingredient) => _IngredientTile(
              name: ingredient.name,
              quantity: ingredient.quantity,
            ),
          ),
        ],
      ),
    );
  }
}

/// +/− serving counter.
class _ServingSelector extends StatelessWidget {
  const _ServingSelector({
    required this.servings,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int servings;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoundButton(
            icon: Icons.remove,
            onTap: onDecrement,
            enabled: servings > 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$servings',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _RoundButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary : AppColors.border,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.surface : AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// A single ingredient row showing an icon, name, and quantity.
class _IngredientTile extends StatelessWidget {
  const _IngredientTile({
    required this.name,
    required this.quantity,
  });

  final String name;
  final String quantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            // Ingredient icon placeholder
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.eco_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Name
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Quantity
            Text(quantity, style: AppTextStyles.bodySecondary),
          ],
        ),
      ),
    );
  }
}

/// Prominent fixed "Start Cooking" button at the bottom.
class _StartCookingButton extends StatelessWidget {
  const _StartCookingButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppConstants.pagePadding,
        12,
        AppConstants.pagePadding,
        12 + bottomPadding,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Start Cooking'),
        ),
      ),
    );
  }
}
