import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/recipe.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/home/category_section.dart';
import '../../widgets/home/home_header.dart';
import '../../widgets/home/promo_banner.dart';
import '../../widgets/home/recipe_card.dart';
import '../../widgets/home/recipe_search_bar.dart';
import '../recipe_details/recipe_details_screen.dart';

/// The application's Home screen.
///
/// Assembles the header, search bar, promo banner, categories,
/// and the "Quick & Easy" recipe list. Recipes are loaded from
/// Firestore via [RecipeProvider].
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _categories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
  ];

  String _selectedCategory = 'All';
  String _searchQuery = '';
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Load recipes on first build.
    // Using addPostFrameCallback so context.read is safe.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RecipeProvider>();
      if (!provider.hasData && !provider.isLoading) {
        provider.loadRecipes();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Recipe> _filterRecipes(List<Recipe> recipes) {
    var result = recipes;
    if (_selectedCategory != 'All') {
      result = result.where((r) => r.category == _selectedCategory).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      result = result.where((r) {
        final matchesName = r.name.toLowerCase().contains(query);
        final matchesCategory = r.category.toLowerCase().contains(query);
        final matchesIngredient = r.ingredients.any(
          (i) => i.name.toLowerCase().contains(query),
        );
        return matchesName || matchesCategory || matchesIngredient;
      }).toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, recipeProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              children: [
                // ── Header ──────────────────────────────────────────────
                const HomeHeader(),
                const SizedBox(height: 20),

                // ── Search bar ──────────────────────────────────────────
                RecipeSearchBar(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() => _searchQuery = val);
                  },
                  onClear: () {
                    setState(() => _searchQuery = '');
                  },
                ),
                const SizedBox(height: 20),

                // ── Promo banner ────────────────────────────────────────
                const PromoBanner(),
                const SizedBox(height: 24),

                // ── Categories ──────────────────────────────────────────
                CategorySection(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onSelected: (category) {
                    setState(() => _selectedCategory = category);
                  },
                ),
                const SizedBox(height: 24),

                // ── Quick & Easy (state-aware) ──────────────────────────
                _buildRecipeSection(recipeProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecipeSection(RecipeProvider provider) {
    // ── Loading state ───────────────────────────────────────────
    if (provider.isLoading) {
      return const _LoadingSection();
    }

    // ── Error state ─────────────────────────────────────────────
    if (provider.errorMessage != null) {
      return _ErrorSection(
        message: provider.errorMessage!,
        onRetry: () => provider.loadRecipes(),
      );
    }

    // ── Empty collection state ──────────────────────────────────
    if (provider.recipes.isEmpty) {
      return const _EmptySection();
    }

    final filtered = _filterRecipes(provider.recipes);

    // ── No search results state ─────────────────────────────────
    if (filtered.isEmpty && _searchQuery.trim().isNotEmpty) {
      return _NoSearchResultsSection(
        query: _searchQuery.trim(),
        onClear: () {
          _searchController.clear();
          setState(() => _searchQuery = '');
        },
      );
    }

    // ── Success / filtered state ────────────────────────────────
    return _QuickAndEasySection(recipes: filtered);
  }
}

// ─────────────────────────────────────────────────────────────────────
// Private helper widgets
// ─────────────────────────────────────────────────────────────────────

class _QuickAndEasySection extends StatelessWidget {
  const _QuickAndEasySection({required this.recipes});

  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.pagePadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick & Easy', style: AppTextStyles.headingSmall),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'No recipes in this category.',
                style: AppTextStyles.bodySecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.pagePadding,
          ),
          child: Text('Quick & Easy', style: AppTextStyles.headingSmall),
        ),
        const SizedBox(height: 12),

        // Horizontal recipe list
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.pagePadding,
            ),
            itemCount: recipes.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return RecipeCard(
                recipe: recipe,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => RecipeDetailsScreen(recipe: recipe),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Loading indicator shown while recipes are being fetched.
class _LoadingSection extends StatelessWidget {
  const _LoadingSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.pagePadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick & Easy', style: AppTextStyles.headingSmall),
          const SizedBox(height: 40),
          const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Loading recipes…',
              style: AppTextStyles.bodySecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error state with a retry button.
class _ErrorSection extends StatelessWidget {
  const _ErrorSection({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.pagePadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick & Easy', style: AppTextStyles.headingSmall),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 56,
                  color: AppColors.border,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state shown when Firestore returns zero recipes.
class _EmptySection extends StatelessWidget {
  const _EmptySection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.pagePadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick & Easy', style: AppTextStyles.headingSmall),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.restaurant_menu_rounded,
                  size: 56,
                  color: AppColors.border,
                ),
                const SizedBox(height: 12),
                Text(
                  'No recipes available yet.',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown when a search query yields no matching recipes.
class _NoSearchResultsSection extends StatelessWidget {
  const _NoSearchResultsSection({
    required this.query,
    required this.onClear,
  });

  final String query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.pagePadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Search Results', style: AppTextStyles.headingSmall),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.search_off_rounded,
                  size: 56,
                  color: AppColors.border,
                ),
                const SizedBox(height: 12),
                Text(
                  'No recipes found for "$query"',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Try searching by ingredient or a different keyword.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.clear_rounded),
                  label: const Text('Clear Search'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

