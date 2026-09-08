import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recipe_app/core/constants/mock_data.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/screens/recipe_details/recipe_details_screen.dart';

void main() {
  testWidgets('App renders Home screen with key sections',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeApp());

    // Header greeting is visible.
    expect(find.textContaining('cooking today'), findsOneWidget);

    // Search bar hint is visible.
    expect(find.text('Search recipes'), findsOneWidget);

    // Category section is visible.
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);

    // Quick & Easy section is visible.
    expect(find.text('Quick & Easy'), findsOneWidget);

    // Bottom navigation items are visible.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Meal Plan'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Recipe Details screen shows recipe information',
      (WidgetTester tester) async {
    final recipe = mockRecipes.first;

    await tester.pumpWidget(
      MaterialApp(
        home: RecipeDetailsScreen(recipe: recipe),
      ),
    );

    // Recipe name is visible.
    expect(find.text(recipe.name), findsOneWidget);

    // Rating is visible.
    expect(find.text(recipe.rating.toStringAsFixed(1)), findsOneWidget);

    // Metadata is visible.
    expect(find.text('${recipe.calories} cal'), findsOneWidget);
    expect(find.text('${recipe.timeMinutes} min'), findsOneWidget);

    // Ingredients section is visible.
    expect(find.text('Ingredients'), findsOneWidget);

    // First ingredient name is visible.
    expect(find.text(recipe.ingredients.first.name), findsOneWidget);

    // Start Cooking button is visible.
    expect(find.text('Start Cooking'), findsOneWidget);
  });

  testWidgets('Serving selector increments and decrements',
      (WidgetTester tester) async {
    final recipe = mockRecipes.first; // defaultServings = 2

    await tester.pumpWidget(
      MaterialApp(
        home: RecipeDetailsScreen(recipe: recipe),
      ),
    );

    // Initial serving count.
    expect(find.text('${recipe.defaultServings}'), findsOneWidget);

    // Tap increment.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('${recipe.defaultServings + 1}'), findsOneWidget);

    // Tap decrement twice (back to original, then to 1).
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('${recipe.defaultServings}'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('${recipe.defaultServings - 1}'), findsOneWidget);
  });

  testWidgets('Favorite button toggles', (WidgetTester tester) async {
    final recipe = mockRecipes.first;

    await tester.pumpWidget(
      MaterialApp(
        home: RecipeDetailsScreen(recipe: recipe),
      ),
    );

    // Initially not favorite — outline icon shown.
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_rounded), findsNothing);

    // Tap favorite.
    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.pump();

    // Now filled icon shown.
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
  });
}