import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/mock_data.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/recipe.dart';
import '../../services/favorite_state.dart';
import '../../widgets/home/category_section.dart';
import '../../widgets/home/home_header.dart';
import '../../widgets/home/promo_banner.dart';
import '../../widgets/home/recipe_card.dart';
import '../../widgets/home/recipe_search_bar.dart';
import '../recipe_details/recipe_details_screen.dart';

/// The application's Home screen.
///
/// Assembles the header, search bar, promo banner, categories,
/// and the "Quick & Easy" recipe list. The screen is vertically
/// scrollable while horizontal sections scroll independently.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.favoriteState});

  final FavoriteState favoriteState;

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

  List<Recipe> get _filteredRecipes {
    if (_selectedCategory == 'All') return mockRecipes;
    return mockRecipes
        .where((r) => r.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final recipes = _filteredRecipes;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        children: [
          // ── Header ──────────────────────────────────────────────
          const HomeHeader(),
          const SizedBox(height: 20),

          // ── Search bar ──────────────────────────────────────────
          const RecipeSearchBar(),
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

          // ── Quick & Easy ────────────────────────────────────────
          _QuickAndEasySection(
            recipes: recipes,
            favoriteState: widget.favoriteState,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Private helper widget to keep HomeScreen concise.
// ─────────────────────────────────────────────────────────────────────

class _QuickAndEasySection extends StatelessWidget {
  const _QuickAndEasySection({
    required this.recipes,
    required this.favoriteState,
  });

  final List<Recipe> recipes;
  final FavoriteState favoriteState;

  @override
  Widget build(BuildContext context) {
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
                      builder: (_) => RecipeDetailsScreen(
                        recipe: recipe,
                        favoriteState: favoriteState,
                      ),
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
