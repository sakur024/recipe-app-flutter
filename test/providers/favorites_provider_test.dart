import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/providers/favorites_provider.dart';

void main() {
  late FavoritesProvider provider;
  late Recipe testRecipe1;
  late Recipe testRecipe2;

  setUp(() {
    provider = FavoritesProvider();
    testRecipe1 = const Recipe(
      name: 'Avocado Toast',
      imageUrl: 'https://example.com/avocado.jpg',
      calories: 320,
      timeMinutes: 15,
      category: 'Breakfast',
      rating: 4.8,
      reviewCount: 120,
    );
    testRecipe2 = const Recipe(
      name: 'Berry Smoothie Bowl',
      imageUrl: 'https://example.com/smoothie.jpg',
      calories: 280,
      timeMinutes: 10,
      category: 'Breakfast',
      rating: 4.9,
      reviewCount: 95,
    );
  });

  group('FavoritesProvider', () {
    // 1. Provider starts with no favorites.
    test('starts with no favorites', () {
      expect(provider.favorites, isEmpty);
      expect(provider.count, 0);
      expect(provider.isEmpty, isTrue);
    });

    // 2. A recipe can be added.
    test('a recipe can be added', () {
      provider.addFavorite(testRecipe1);
      expect(provider.favorites, contains(testRecipe1));
      expect(provider.count, 1);
      expect(provider.isEmpty, isFalse);
    });

    // 3. Added recipe is reported as favorite.
    test('added recipe is reported as favorite', () {
      provider.addFavorite(testRecipe1);
      expect(provider.isFavorite(testRecipe1), isTrue);
      expect(provider.isFavorite(testRecipe2), isFalse);
    });

    // 4. A recipe can be removed.
    test('a recipe can be removed', () {
      provider.addFavorite(testRecipe1);
      expect(provider.count, 1);

      provider.removeFavorite(testRecipe1);
      expect(provider.favorites, isEmpty);
      expect(provider.count, 0);
    });

    // 5. Removed recipe is no longer favorite.
    test('removed recipe is no longer favorite', () {
      provider.addFavorite(testRecipe1);
      provider.removeFavorite(testRecipe1);
      expect(provider.isFavorite(testRecipe1), isFalse);
    });

    // 6. Toggle adds a non-favorite recipe.
    test('toggle adds a non-favorite recipe', () {
      expect(provider.isFavorite(testRecipe1), isFalse);

      provider.toggleFavorite(testRecipe1);
      expect(provider.isFavorite(testRecipe1), isTrue);
      expect(provider.favorites, contains(testRecipe1));
      expect(provider.count, 1);
    });

    // 7. Toggle removes a favorite recipe.
    test('toggle removes a favorite recipe', () {
      provider.addFavorite(testRecipe1);
      expect(provider.isFavorite(testRecipe1), isTrue);

      provider.toggleFavorite(testRecipe1);
      expect(provider.isFavorite(testRecipe1), isFalse);
      expect(provider.favorites, isEmpty);
      expect(provider.count, 0);
    });

    // 8. Favorites list contains the correct recipes.
    test('favorites list contains the correct recipes in insertion order', () {
      provider.addFavorite(testRecipe1);
      provider.addFavorite(testRecipe2);

      expect(provider.favorites, equals([testRecipe1, testRecipe2]));
      expect(provider.favorites.length, 2);
      expect(provider.favorites[0].name, 'Avocado Toast');
      expect(provider.favorites[1].name, 'Berry Smoothie Bowl');
    });

    // 9. Provider notifies listeners after changes.
    test('notifies listeners after changes and avoids redundant notifications', () {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      // Adding recipe notifies listeners
      provider.addFavorite(testRecipe1);
      expect(notifyCount, 1);

      // Adding same recipe again does not duplicate or notify
      provider.addFavorite(testRecipe1);
      expect(notifyCount, 1);

      // Removing recipe notifies listeners
      provider.removeFavorite(testRecipe1);
      expect(notifyCount, 2);

      // Removing non-existent recipe does not notify
      provider.removeFavorite(testRecipe1);
      expect(notifyCount, 2);

      // Toggle adds and notifies
      provider.toggleFavorite(testRecipe2);
      expect(notifyCount, 3);

      // Toggle removes and notifies
      provider.toggleFavorite(testRecipe2);
      expect(notifyCount, 4);
    });
  });
}
