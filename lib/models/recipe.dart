import 'ingredient.dart';

/// Data model for a recipe displayed in the app.
///
/// Contains fields needed by both the Home screen and the
/// Recipe Details screen. Will be extended when Firestore is added.
class Recipe {
  const Recipe({
    required this.name,
    required this.imageUrl,
    required this.calories,
    required this.timeMinutes,
    required this.category,
    required this.rating,
    required this.reviewCount,
    this.defaultServings = 1,
    this.ingredients = const [],
  });

  final String name;
  final String imageUrl;
  final int calories;
  final int timeMinutes;
  final String category;
  final double rating;
  final int reviewCount;

  /// Default number of servings for the recipe.
  final int defaultServings;

  /// List of ingredients with their base quantities.
  final List<Ingredient> ingredients;
}
