import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/meal_plan_item.dart';
import '../../models/recipe.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/recipe_provider.dart';
import '../recipe_details/recipe_details_screen.dart';

/// Screen for viewing and managing daily and weekly meal plans.
class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MealPlanProvider>(
      builder: (context, mealPlan, child) {
        final selectedDate = mealPlan.selectedDate;
        final meals = mealPlan.mealsForSelectedDate;

        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Title Bar ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.pagePadding,
                    16,
                    AppConstants.pagePadding,
                    8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Meal Plan', style: AppTextStyles.headingLarge),
                            const SizedBox(height: 2),
                            Text(
                              'Plan your healthy week',
                              style: AppTextStyles.bodySecondary,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showAddMealSheet(context),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.surface,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ── Week Calendar Strip ───────────────────────────
                _WeekDaySelector(
                  selectedDate: selectedDate,
                  onDateSelected: (date) => mealPlan.selectDate(date),
                ),

                const SizedBox(height: 16),

                // ── Meal Items for Selected Day ───────────────────
                Expanded(
                  child: meals.isEmpty
                      ? _EmptyMealPlan(onAddMeal: () => _showAddMealSheet(context))
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppConstants.pagePadding,
                            4,
                            AppConstants.pagePadding,
                            24,
                          ),
                          itemCount: meals.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = meals[index];
                            return _MealPlanCard(
                              item: item,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => RecipeDetailsScreen(
                                      recipe: item.recipe,
                                    ),
                                  ),
                                );
                              },
                              onRemove: () => mealPlan.removeMeal(item.id),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddMealSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _AddMealBottomSheet(),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════
// Sub-widgets
// ═════════════════════════════════════════════════════════════════════

/// Horizontal selector for the surrounding 14 days.
class _WeekDaySelector extends StatelessWidget {
  const _WeekDaySelector({
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  static const List<String> _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Generate dates from today - 2 days to today + 11 days (14 days total)
    final days = List.generate(
      14,
      (index) => today.subtract(const Duration(days: 2)).add(Duration(days: index)),
    );

    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.pagePadding,
        ),
        itemCount: days.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = day.year == selectedDate.year &&
              day.month == selectedDate.month &&
              day.day == selectedDate.day;

          final weekday = _weekdays[day.weekday - 1];

          return GestureDetector(
            onTap: () => onDateSelected(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 58,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 0.8,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekday,
                    style: AppTextStyles.label.copyWith(
                      color: isSelected
                          ? AppColors.surface.withValues(alpha: 0.85)
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${day.day}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.surface
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A card representing a planned meal item.
class _MealPlanCard extends StatelessWidget {
  const _MealPlanCard({
    required this.item,
    required this.onTap,
    required this.onRemove,
  });

  final MealPlanItem item;
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
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Recipe image thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.recipe.imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 80,
                  width: 80,
                  color: AppColors.primaryLight,
                  child: const Icon(
                    Icons.restaurant_rounded,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Recipe info & meal type
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.mealType.label,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.recipe.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.recipe.calories} cal · ${item.recipe.timeMinutes} min',
                    style: AppTextStyles.label,
                  ),
                ],
              ),
            ),

            // Remove button
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.textSecondary,
                size: 22,
              ),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state when no meals are planned on the selected day.
class _EmptyMealPlan extends StatelessWidget {
  const _EmptyMealPlan({required this.onAddMeal});

  final VoidCallback onAddMeal;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.pagePadding * 1.5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No meals planned',
              style: AppTextStyles.headingSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add breakfast, lunch, or dinner to this day to keep your nutrition on track.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onAddMeal,
              style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add Meal'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet dialog to select a meal type and recipe.
class _AddMealBottomSheet extends StatefulWidget {
  const _AddMealBottomSheet();

  @override
  State<_AddMealBottomSheet> createState() => _AddMealBottomSheetState();
}

class _AddMealBottomSheetState extends State<_AddMealBottomSheet> {
  MealType _selectedType = MealType.lunch;
  Recipe? _selectedRecipe;

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final recipes = recipeProvider.recipes.isNotEmpty
        ? recipeProvider.recipes
        : mockRecipes;

    if (_selectedRecipe == null && recipes.isNotEmpty) {
      _selectedRecipe = recipes.first;
    }

    return Padding(
      padding: EdgeInsets.only(
        left: AppConstants.pagePadding,
        right: AppConstants.pagePadding,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Plan a Meal', style: AppTextStyles.headingSmall),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Meal type chips
          Text('Meal Type', style: AppTextStyles.label),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: MealType.values.map((type) {
              final isChosen = type == _selectedType;
              return ChoiceChip(
                label: Text(type.label),
                selected: isChosen,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isChosen ? AppColors.surface : AppColors.textPrimary,
                  fontWeight: isChosen ? FontWeight.w600 : FontWeight.w400,
                ),
                onSelected: (_) => setState(() => _selectedType = type),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          Text('Select Recipe', style: AppTextStyles.label),
          const SizedBox(height: 8),

          // Recipe selection list
          SizedBox(
            height: 180,
            child: ListView.separated(
              itemCount: recipes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                final isSelected = recipe.name == _selectedRecipe?.name;

                return InkWell(
                  onTap: () => setState(() => _selectedRecipe = recipe),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryLight
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            recipe.name,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          '${recipe.calories} cal',
                          style: AppTextStyles.label,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedRecipe == null
                  ? null
                  : () {
                      final mealPlan = context.read<MealPlanProvider>();
                      mealPlan.addMeal(
                        date: mealPlan.selectedDate,
                        mealType: _selectedType,
                        recipe: _selectedRecipe!,
                      );
                      Navigator.of(context).pop();
                    },
              style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Add to Plan'),
            ),
          ),
        ],
      ),
    );
  }
}
