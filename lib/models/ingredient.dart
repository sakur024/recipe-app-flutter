/// A single ingredient used in a recipe.
class Ingredient {
  const Ingredient({
    required this.name,
    required this.quantity,
    this.imageUrl,
  });

  /// Display name (e.g. "Mozzarella Cheese").
  final String name;

  /// Base quantity for the recipe's default serving size (e.g. "200g").
  final String quantity;

  /// Optional small image URL for the ingredient.
  final String? imageUrl;
}
