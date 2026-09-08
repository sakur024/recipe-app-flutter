import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recipe_app/core/constants/mock_data.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/screens/favorites/favorites_screen.dart';
import 'package:recipe_app/screens/recipe_details/recipe_details_screen.dart';
import 'package:recipe_app/services/favorite_state.dart';

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

  testWidgets('Category filtering works on Home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeApp());

    // Tap Breakfast category
    await tester.tap(find.text('Breakfast'));
    await tester.pumpAndSettle();

    // Breakfast recipes like French Toast should be visible
    expect(find.text('French Toast'), findsOneWidget);
  });

  testWidgets('Recipe Details screen shows recipe information',
      (WidgetTester tester) async {
    final recipe = mockRecipes.first;
    final favoriteState = FavoriteState();

    await tester.pumpWidget(
      MaterialApp(
        home: RecipeDetailsScreen(
          recipe: recipe,
          favoriteState: favoriteState,
        ),
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
    final favoriteState = FavoriteState();

    await tester.pumpWidget(
      MaterialApp(
        home: RecipeDetailsScreen(
          recipe: recipe,
          favoriteState: favoriteState,
        ),
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

  testWidgets('Favorite button toggles in RecipeDetailsScreen and updates FavoriteState',
      (WidgetTester tester) async {
    final recipe = mockRecipes.first;
    final favoriteState = FavoriteState();

    await tester.pumpWidget(
      MaterialApp(
        home: RecipeDetailsScreen(
          recipe: recipe,
          favoriteState: favoriteState,
        ),
      ),
    );

    // Initially not favorite — outline icon shown.
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_rounded), findsNothing);
    expect(favoriteState.isFavorite(recipe), isFalse);

    // Tap favorite.
    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.pump();

    // Now filled icon shown and state updated.
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
    expect(favoriteState.isFavorite(recipe), isTrue);

    // Tap favorite again to unfavorite.
    await tester.tap(find.byIcon(Icons.favorite_rounded));
    await tester.pump();

    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_rounded), findsNothing);
    expect(favoriteState.isFavorite(recipe), isFalse);
  });

  testWidgets('Favorites screen renders empty state when no favorites exist',
      (WidgetTester tester) async {
    final favoriteState = FavoriteState();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FavoritesScreen(favoriteState: favoriteState),
        ),
      ),
    );

    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('No favorites yet'), findsOneWidget);
    expect(find.text('Tap the heart icon on any recipe\nto save it here.'),
        findsOneWidget);
  });

  testWidgets('Favoriting recipe makes it appear in FavoritesScreen and unfavoriting removes it',
      (WidgetTester tester) async {
    final recipe = mockRecipes.first;
    final favoriteState = FavoriteState();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FavoritesScreen(favoriteState: favoriteState),
        ),
      ),
    );

    // Initially empty.
    expect(find.text('No favorites yet'), findsOneWidget);
    expect(find.text(recipe.name), findsNothing);

    // Favorite the recipe.
    favoriteState.toggle(recipe);
    await tester.pump();

    // Now visible in FavoritesScreen.
    expect(find.text('No favorites yet'), findsNothing);
    expect(find.text(recipe.name), findsOneWidget);

    // Unfavorite via the heart button on the favorite card.
    await tester.tap(find.byIcon(Icons.favorite_rounded));
    await tester.pump();

    // Empty state returns.
    expect(find.text('No favorites yet'), findsOneWidget);
    expect(find.text(recipe.name), findsNothing);
  });

  testWidgets('Full flow: Home -> Recipe Details -> Favorite -> Back -> Favorites -> Details -> Unfavorite -> Back',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const RecipeApp());

    // 1. Home screen is loaded
    expect(find.text('Quick & Easy'), findsOneWidget);
    final targetRecipe = mockRecipes.first;

    // 2. Tap recipe card on Home
    await tester.tap(find.text(targetRecipe.name).first);
    await tester.pumpAndSettle();

    // 3. We are on Recipe Details Screen
    expect(find.text('Start Cooking'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);

    // 4. Tap favorite icon
    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

    // 5. Navigate back to Home
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    // 6. Navigate to Favorites tab using bottom nav
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();

    // 7. Favorited recipe is displayed in Favorites
    expect(find.text('Favorites'), findsNWidgets(2));
    expect(find.text(targetRecipe.name), findsOneWidget);

    // 8. Tap the recipe card to open Recipe Details
    await tester.tap(find.text(targetRecipe.name));
    await tester.pumpAndSettle();

    // 9. Recipe Details opens and favorite icon is active
    expect(find.text('Start Cooking'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

    // 10. Unfavorite it
    await tester.tap(find.byIcon(Icons.favorite_rounded));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);

    // 11. Go back to Favorites screen
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    // 12. Recipe is removed and empty state is shown
    expect(find.text('No favorites yet'), findsOneWidget);
    expect(find.text(targetRecipe.name), findsNothing);
  });
}