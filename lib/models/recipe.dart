/// Data model for a recipe displayed in the app.
///
/// Contains only the fields needed by the Home screen at this milestone.
/// Will be extended when recipe details and Firestore are added.
class Recipe {
  const Recipe({
    required this.name,
    required this.imageUrl,
    required this.calories,
    required this.timeMinutes,
    required this.category,
    required this.rating,
    required this.reviewCount,
  });

  final String name;
  final String imageUrl;
  final int calories;
  final int timeMinutes;
  final String category;
  final double rating;
  final int reviewCount;
}
