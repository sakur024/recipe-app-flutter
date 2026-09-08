class Recipe {
  const Recipe({
    required this.name,
    required this.imageUrl,
    required this.calories,
    required this.timeMinutes,
    required this.category,
  });

  final String name;
  final String imageUrl;
  final int calories;
  final int timeMinutes;
  final String category;
}
