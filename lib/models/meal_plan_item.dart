import 'recipe.dart';

/// Supported meal categories for planning.
enum MealType {
  breakfast('Breakfast'),
  lunch('Lunch'),
  dinner('Dinner'),
  snack('Snack');

  const MealType(this.label);
  final String label;
}

/// A planned recipe for a specific calendar date and meal type.
class MealPlanItem {
  MealPlanItem({
    required this.id,
    required this.date,
    required this.mealType,
    required this.recipe,
  });

  final String id;
  final DateTime date;
  final MealType mealType;
  final Recipe recipe;
}
