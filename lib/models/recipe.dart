import 'ingredient.dart';

/// Data model for a recipe displayed in the app.
///
/// Contains fields needed by both the Home screen and the
/// Recipe Details screen. Supports Firestore serialisation via
/// [fromMap] / [toMap].
class Recipe {
  const Recipe({
    this.id,
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

  /// Firestore document ID. `null` for local-only recipes.
  final String? id;

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

  /// Creates a [Recipe] from a Firestore-style [Map] and a document [id].
  ///
  /// Missing or malformed fields fall back to sensible defaults so a
  /// single corrupt document cannot crash the entire recipe list.
  factory Recipe.fromMap(Map<String, dynamic> map, String id) {
    final rawIngredients = map['ingredients'];
    final List<Ingredient> parsedIngredients;
    if (rawIngredients is List) {
      parsedIngredients = rawIngredients
          .whereType<Map<String, dynamic>>()
          .map(Ingredient.fromMap)
          .toList();
    } else {
      parsedIngredients = const [];
    }

    return Recipe(
      id: id,
      name: (map['name'] as String?) ?? 'Untitled Recipe',
      imageUrl: (map['imageUrl'] as String?) ?? '',
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      timeMinutes: (map['timeMinutes'] as num?)?.toInt() ?? 0,
      category: (map['category'] as String?) ?? 'Other',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      defaultServings: (map['defaultServings'] as num?)?.toInt() ?? 1,
      ingredients: parsedIngredients,
    );
  }

  /// Converts this recipe into a Firestore-friendly [Map].
  ///
  /// The document ID is NOT included in the map because Firestore
  /// stores it as the document path, not as a field.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'calories': calories,
      'timeMinutes': timeMinutes,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'defaultServings': defaultServings,
      'ingredients': ingredients.map((i) => i.toMap()).toList(),
    };
  }
}
