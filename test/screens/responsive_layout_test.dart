import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recipe_app/core/constants/mock_data.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/providers/favorites_provider.dart';
import 'package:recipe_app/providers/meal_plan_provider.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/providers/settings_provider.dart';
import 'package:recipe_app/screens/favorites/favorites_screen.dart';
import 'package:recipe_app/screens/home/home_screen.dart';
import 'package:recipe_app/screens/meal_plan/meal_plan_screen.dart';
import 'package:recipe_app/screens/recipe_details/recipe_details_screen.dart';
import 'package:recipe_app/screens/settings/settings_screen.dart';
import 'package:recipe_app/services/recipe_service.dart';

class _FakeRecipeService extends RecipeService {
  _FakeRecipeService() : super(firestore: null);
  @override
  Future<List<Recipe>> fetchAllRecipes() async => mockRecipes;
}

Widget _buildResponsiveApp({Widget? child}) {
  final rp = RecipeProvider(recipeService: _FakeRecipeService());
  rp.loadRecipes();
  final fp = FavoritesProvider();
  fp.addFavorite(mockRecipes.first);
  final mp = MealPlanProvider();
  final sp = SettingsProvider();

  return RecipeApp(
    home: child ?? const MainShell(),
    recipeProvider: rp,
    favoritesProvider: fp,
    mealPlanProvider: mp,
    settingsProvider: sp,
  );
}

void main() {
  const phoneSizes = [
    Size(360, 640), // Small Android (compact)
    Size(390, 844), // iPhone 12/13/14/15 standard
    Size(412, 915), // Pixel / modern large Android
  ];

  for (final size in phoneSizes) {
    group('Mobile viewport ${size.width}x${size.height}', () {
      testWidgets('HomeScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(_buildResponsiveApp(child: const HomeScreen()));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Quick & Easy'), findsOneWidget);
      });

      testWidgets('RecipeDetailsScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          _buildResponsiveApp(
            child: RecipeDetailsScreen(recipe: mockRecipes.first),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Ingredients'), findsOneWidget);
        expect(find.text('Start Cooking'), findsOneWidget);
      });

      testWidgets('FavoritesScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          _buildResponsiveApp(child: const FavoritesScreen()),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Favorites'), findsOneWidget);
      });

      testWidgets('MealPlanScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          _buildResponsiveApp(child: const MealPlanScreen()),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Meal Plan'), findsOneWidget);
      });

      testWidgets('SettingsScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          _buildResponsiveApp(child: const SettingsScreen()),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Settings'), findsOneWidget);
      });

      testWidgets('MainShell bottom navigation renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(_buildResponsiveApp(child: const MainShell()));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Favorites'), findsOneWidget);
        expect(find.text('Meal Plan'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
      });
    });
  }
}
