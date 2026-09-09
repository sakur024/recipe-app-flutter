import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recipe_app/core/constants/mock_data.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/providers/favorites_provider.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/services/recipe_service.dart';

class _FakeRecipeService extends RecipeService {
  _FakeRecipeService() : super(firestore: null);
  @override
  Future<List<Recipe>> fetchAllRecipes() async => mockRecipes;
}

Widget _buildTestApp() {
  final recipeProvider = RecipeProvider(recipeService: _FakeRecipeService());
  recipeProvider.loadRecipes();

  return RecipeApp(
    recipeProvider: recipeProvider,
    favoritesProvider: FavoritesProvider(),
  );
}

void main() {
  testWidgets('Searching filters recipes by name', (WidgetTester tester) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    // Initially multiple recipes are visible
    expect(find.text('Mexican Pizza'), findsOneWidget);
    expect(find.text('French Toast'), findsOneWidget);

    // Enter search term "Pizza"
    await tester.enterText(find.byType(TextField), 'Pizza');
    await tester.pumpAndSettle();

    // Mexican Pizza matches, French Toast does not
    expect(find.text('Mexican Pizza'), findsOneWidget);
    expect(find.text('French Toast'), findsNothing);
  });

  testWidgets('Searching filters recipes by ingredient', (WidgetTester tester) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    // Enter "Rosemary" which is in Beef Steak
    await tester.enterText(find.byType(TextField), 'Rosemary');
    await tester.pumpAndSettle();

    expect(find.text('Beef Steak'), findsOneWidget);
    expect(find.text('Mexican Pizza'), findsNothing);
  });

  testWidgets('No search results shows empty state and clear button restores list',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    // Search for non-existent recipe
    await tester.enterText(find.byType(TextField), 'NonExistentDish123');
    await tester.pumpAndSettle();

    expect(find.textContaining('No recipes found for "NonExistentDish123"'), findsOneWidget);
    expect(find.text('Clear Search'), findsOneWidget);

    // Tap "Clear Search"
    await tester.tap(find.text('Clear Search'));
    await tester.pumpAndSettle();

    // Recipes restored
    expect(find.text('Mexican Pizza'), findsOneWidget);
    expect(find.text('French Toast'), findsOneWidget);
  });
}
