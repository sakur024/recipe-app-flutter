import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/recipe.dart';
import '../../widgets/home/category_section.dart';
import '../../widgets/home/home_header.dart';
import '../../widgets/home/promo_banner.dart';
import '../../widgets/home/recipe_card.dart';
import '../../widgets/home/recipe_search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const recipes = [
    Recipe(
      name: 'Mexican Pizza',
      imageUrl:
          'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=600&q=80',
      calories: 140,
      timeMinutes: 25,
      category: 'Dinner',
    ),
    Recipe(
      name: 'French Toast',
      imageUrl:
          'https://images.unsplash.com/photo-1484723091739-30a097e8f929?auto=format&fit=crop&w=600&q=80',
      calories: 110,
      timeMinutes: 15,
      category: 'Breakfast',
    ),
    Recipe(
      name: 'Spicy Ramen Noodles',
      imageUrl:
          'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=600&q=80',
      calories: 120,
      timeMinutes: 15,
      category: 'Lunch',
    ),
    Recipe(
      name: 'Beef Steak',
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=600&q=80',
      calories: 140,
      timeMinutes: 25,
      category: 'Dinner',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const HomeHeader(),
                const SizedBox(height: 20),
                const RecipeSearchBar(),
                const SizedBox(height: 16),
                const PromoBanner(),
                const SizedBox(height: 22),
                const CategorySection(),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Quick & Easy', style: AppTextStyles.title),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 235,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recipes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      return RecipeCard(recipe: recipes[index]);
                    },
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
