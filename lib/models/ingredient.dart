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

  /// Creates an [Ingredient] from a Firestore-style [Map].
  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: (map['name'] as String?) ?? 'Unknown',
      quantity: (map['quantity'] as String?) ?? '',
      imageUrl: map['imageUrl'] as String?,
    );
  }

  /// Converts this ingredient into a Firestore-friendly [Map].
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}
