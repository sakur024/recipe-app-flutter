import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/models/ingredient.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/services/recipe_service.dart';

// ═════════════════════════════════════════════════════════════════════
// Fake RecipeService for unit tests
// ═════════════════════════════════════════════════════════════════════

/// A [RecipeService] substitute that returns canned data without Firestore.
class FakeRecipeService extends RecipeService {
  FakeRecipeService() : super(firestore: null);

  List<Recipe> stubbedRecipes = [];
  bool shouldFail = false;
  String failMessage = 'Network error';

  @override
  Future<List<Recipe>> fetchAllRecipes() async {
    if (shouldFail) throw Exception(failMessage);
    return stubbedRecipes;
  }

  @override
  Future<Recipe?> fetchRecipeById(String id) async {
    if (shouldFail) throw Exception(failMessage);
    try {
      return stubbedRecipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}

void main() {
  // ─── Ingredient.fromMap / toMap ──────────────────────────────────
  group('Ingredient serialisation', () {
    test('fromMap creates Ingredient from valid map', () {
      final map = {'name': 'Sugar', 'quantity': '100g'};
      final ingredient = Ingredient.fromMap(map);

      expect(ingredient.name, 'Sugar');
      expect(ingredient.quantity, '100g');
      expect(ingredient.imageUrl, isNull);
    });

    test('fromMap handles optional imageUrl', () {
      final map = {
        'name': 'Butter',
        'quantity': '50g',
        'imageUrl': 'https://example.com/butter.jpg',
      };
      final ingredient = Ingredient.fromMap(map);

      expect(ingredient.imageUrl, 'https://example.com/butter.jpg');
    });

    test('fromMap provides defaults for missing fields', () {
      final ingredient = Ingredient.fromMap(<String, dynamic>{});

      expect(ingredient.name, 'Unknown');
      expect(ingredient.quantity, '');
      expect(ingredient.imageUrl, isNull);
    });

    test('toMap round-trips correctly', () {
      const ingredient = Ingredient(
        name: 'Flour',
        quantity: '200g',
        imageUrl: 'https://example.com/flour.jpg',
      );
      final map = ingredient.toMap();
      final restored = Ingredient.fromMap(map);

      expect(restored.name, ingredient.name);
      expect(restored.quantity, ingredient.quantity);
      expect(restored.imageUrl, ingredient.imageUrl);
    });

    test('toMap omits imageUrl when null', () {
      const ingredient = Ingredient(name: 'Salt', quantity: '1 tsp');
      final map = ingredient.toMap();

      expect(map.containsKey('imageUrl'), isFalse);
    });
  });

  // ─── Recipe.fromMap / toMap ──────────────────────────────────────
  group('Recipe serialisation', () {
    test('fromMap creates Recipe from valid Firestore-style map', () {
      final map = <String, dynamic>{
        'name': 'Test Recipe',
        'imageUrl': 'https://example.com/recipe.jpg',
        'calories': 350,
        'timeMinutes': 25,
        'category': 'Dinner',
        'rating': 4.7,
        'reviewCount': 100,
        'defaultServings': 4,
        'ingredients': [
          {'name': 'Chicken', 'quantity': '500g'},
          {'name': 'Olive Oil', 'quantity': '2 tbsp'},
        ],
      };

      final recipe = Recipe.fromMap(map, 'doc_1');

      expect(recipe.id, 'doc_1');
      expect(recipe.name, 'Test Recipe');
      expect(recipe.imageUrl, 'https://example.com/recipe.jpg');
      expect(recipe.calories, 350);
      expect(recipe.timeMinutes, 25);
      expect(recipe.category, 'Dinner');
      expect(recipe.rating, 4.7);
      expect(recipe.reviewCount, 100);
      expect(recipe.defaultServings, 4);
      expect(recipe.ingredients.length, 2);
      expect(recipe.ingredients[0].name, 'Chicken');
      expect(recipe.ingredients[1].quantity, '2 tbsp');
    });

    test('fromMap provides defaults for missing fields', () {
      final recipe = Recipe.fromMap(<String, dynamic>{}, 'empty_doc');

      expect(recipe.id, 'empty_doc');
      expect(recipe.name, 'Untitled Recipe');
      expect(recipe.imageUrl, '');
      expect(recipe.calories, 0);
      expect(recipe.timeMinutes, 0);
      expect(recipe.category, 'Other');
      expect(recipe.rating, 0.0);
      expect(recipe.reviewCount, 0);
      expect(recipe.defaultServings, 1);
      expect(recipe.ingredients, isEmpty);
    });

    test('fromMap skips malformed ingredient entries', () {
      final map = <String, dynamic>{
        'name': 'Partial',
        'imageUrl': '',
        'calories': 0,
        'timeMinutes': 0,
        'category': 'Test',
        'rating': 0,
        'reviewCount': 0,
        'ingredients': [
          {'name': 'Valid', 'quantity': '1 cup'},
          'not a map', // should be skipped
          42, // should be skipped
        ],
      };

      final recipe = Recipe.fromMap(map, 'partial_doc');
      expect(recipe.ingredients.length, 1);
      expect(recipe.ingredients[0].name, 'Valid');
    });

    test('fromMap handles non-list ingredients gracefully', () {
      final map = <String, dynamic>{
        'name': 'No Ingredients',
        'imageUrl': '',
        'calories': 0,
        'timeMinutes': 0,
        'category': 'Test',
        'rating': 0,
        'reviewCount': 0,
        'ingredients': 'not a list',
      };

      final recipe = Recipe.fromMap(map, 'bad_ingredients');
      expect(recipe.ingredients, isEmpty);
    });

    test('toMap round-trips correctly', () {
      const original = Recipe(
        id: 'round_trip',
        name: 'Round Trip Recipe',
        imageUrl: 'https://example.com/image.jpg',
        calories: 400,
        timeMinutes: 30,
        category: 'Lunch',
        rating: 4.5,
        reviewCount: 50,
        defaultServings: 2,
        ingredients: [
          Ingredient(name: 'Rice', quantity: '200g'),
          Ingredient(name: 'Chicken', quantity: '300g'),
        ],
      );

      final map = original.toMap();
      final restored = Recipe.fromMap(map, 'round_trip');

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.calories, original.calories);
      expect(restored.timeMinutes, original.timeMinutes);
      expect(restored.category, original.category);
      expect(restored.rating, original.rating);
      expect(restored.reviewCount, original.reviewCount);
      expect(restored.defaultServings, original.defaultServings);
      expect(restored.ingredients.length, original.ingredients.length);
    });

    test('toMap does not include id (stored as document path)', () {
      const recipe = Recipe(
        id: 'should_not_appear',
        name: 'Test',
        imageUrl: '',
        calories: 0,
        timeMinutes: 0,
        category: 'Test',
        rating: 0,
        reviewCount: 0,
      );

      expect(recipe.toMap().containsKey('id'), isFalse);
    });
  });

  // ─── RecipeProvider ──────────────────────────────────────────────
  group('RecipeProvider', () {
    late FakeRecipeService fakeService;
    late RecipeProvider provider;

    setUp(() {
      fakeService = FakeRecipeService();
      provider = RecipeProvider(recipeService: fakeService);
    });

    test('initial state is correct', () {
      expect(provider.recipes, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
      expect(provider.hasData, isFalse);
    });

    test('loadRecipes transitions through loading → loaded', () async {
      fakeService.stubbedRecipes = const [
        Recipe(
          id: '1',
          name: 'Test Recipe',
          imageUrl: '',
          calories: 100,
          timeMinutes: 10,
          category: 'Breakfast',
          rating: 4.0,
          reviewCount: 5,
        ),
      ];

      // Capture loading state synchronously.
      bool wasLoading = false;
      provider.addListener(() {
        if (provider.isLoading) wasLoading = true;
      });

      await provider.loadRecipes();

      expect(wasLoading, isTrue);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
      expect(provider.recipes.length, 1);
      expect(provider.recipes.first.name, 'Test Recipe');
      expect(provider.hasData, isTrue);
    });

    test('loadRecipes sets error on failure', () async {
      fakeService.shouldFail = true;

      await provider.loadRecipes();

      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, 'Unable to load recipes. Please try again.');
      expect(provider.recipes, isEmpty);
      expect(provider.hasData, isFalse);
    });

    test('refreshRecipes reloads data', () async {
      fakeService.stubbedRecipes = const [
        Recipe(
          id: '1',
          name: 'First Load',
          imageUrl: '',
          calories: 100,
          timeMinutes: 10,
          category: 'Lunch',
          rating: 4.0,
          reviewCount: 5,
        ),
      ];

      await provider.loadRecipes();
      expect(provider.recipes.first.name, 'First Load');

      fakeService.stubbedRecipes = const [
        Recipe(
          id: '2',
          name: 'After Refresh',
          imageUrl: '',
          calories: 200,
          timeMinutes: 20,
          category: 'Dinner',
          rating: 4.5,
          reviewCount: 10,
        ),
      ];

      await provider.refreshRecipes();
      expect(provider.recipes.first.name, 'After Refresh');
    });

    test('error clears on successful reload', () async {
      fakeService.shouldFail = true;
      await provider.loadRecipes();
      expect(provider.errorMessage, isNotNull);

      fakeService.shouldFail = false;
      fakeService.stubbedRecipes = const [
        Recipe(
          id: '1',
          name: 'Recovered',
          imageUrl: '',
          calories: 100,
          timeMinutes: 10,
          category: 'Breakfast',
          rating: 4.0,
          reviewCount: 5,
        ),
      ];

      await provider.loadRecipes();
      expect(provider.errorMessage, isNull);
      expect(provider.recipes.first.name, 'Recovered');
    });
  });
}
