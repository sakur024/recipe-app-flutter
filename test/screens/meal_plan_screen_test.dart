import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:recipe_app/core/constants/mock_data.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/providers/meal_plan_provider.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/screens/meal_plan/meal_plan_screen.dart';
import 'package:recipe_app/services/recipe_service.dart';

class _FakeRecipeService extends RecipeService {
  _FakeRecipeService() : super(firestore: null);
  @override
  Future<List<Recipe>> fetchAllRecipes() async => mockRecipes;
}

Widget _buildTestableMealPlanScreen({
  required MealPlanProvider mealPlanProvider,
  RecipeProvider? recipeProvider,
}) {
  final rp = recipeProvider ??
      RecipeProvider(recipeService: _FakeRecipeService());

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<MealPlanProvider>.value(value: mealPlanProvider),
      ChangeNotifierProvider<RecipeProvider>.value(value: rp),
    ],
    child: const MaterialApp(
      home: MealPlanScreen(),
    ),
  );
}

void main() {
  testWidgets('MealPlanScreen renders title and weekday strip',
      (WidgetTester tester) async {
    final provider = MealPlanProvider();
    await tester.pumpWidget(_buildTestableMealPlanScreen(mealPlanProvider: provider));
    await tester.pumpAndSettle();

    expect(find.text('Meal Plan'), findsOneWidget);
    expect(find.text('Plan your healthy week'), findsOneWidget);
  });

  testWidgets('MealPlanScreen displays initial sample meals for today',
      (WidgetTester tester) async {
    final provider = MealPlanProvider();
    await tester.pumpWidget(_buildTestableMealPlanScreen(mealPlanProvider: provider));
    await tester.pumpAndSettle();

    expect(find.text('Breakfast'), findsWidgets);
    expect(find.text(mockRecipes[1].name), findsOneWidget); // French Toast
  });

  testWidgets('Selecting a date with no meals shows empty state',
      (WidgetTester tester) async {
    final provider = MealPlanProvider();
    await tester.pumpWidget(_buildTestableMealPlanScreen(mealPlanProvider: provider));
    await tester.pumpAndSettle();

    // Select a date in the far future
    provider.selectDate(DateTime.now().add(const Duration(days: 8)));
    await tester.pumpAndSettle();

    expect(find.text('No meals planned'), findsOneWidget);
    expect(find.text('Add Meal'), findsOneWidget);
  });

  testWidgets('Removing a meal deletes it from UI',
      (WidgetTester tester) async {
    final provider = MealPlanProvider();
    await tester.pumpWidget(_buildTestableMealPlanScreen(mealPlanProvider: provider));
    await tester.pumpAndSettle();

    final removeButtons = find.byIcon(Icons.delete_outline_rounded);
    expect(removeButtons, findsWidgets);

    await tester.tap(removeButtons.first);
    await tester.pumpAndSettle();

    // The count of planned meals for today decreased
    expect(provider.mealsForSelectedDate.length, 1);
  });

  testWidgets('Adding a meal via bottom sheet adds it to the list',
      (WidgetTester tester) async {
    final provider = MealPlanProvider();
    await tester.pumpWidget(_buildTestableMealPlanScreen(mealPlanProvider: provider));
    await tester.pumpAndSettle();

    // Tap the plus button to open add meal sheet
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();

    expect(find.text('Plan a Meal'), findsOneWidget);
    expect(find.text('Add to Plan'), findsOneWidget);

    // Tap "Add to Plan"
    await tester.tap(find.text('Add to Plan'));
    await tester.pumpAndSettle();

    // Sheet dismissed and meals increased
    expect(find.text('Plan a Meal'), findsNothing);
    expect(provider.mealsForSelectedDate.length, 3);
  });

  test('AppTheme light and dark can be lerped without TextStyle.lerp assertion', () {
    expect(() {
      ThemeData.lerp(AppTheme.light, AppTheme.dark, 0.5);
    }, returnsNormally);
  });

  testWidgets(
      'ElevatedButton at line 376 renders and responds to press without TextStyle.lerp assertion',
      (WidgetTester tester) async {
    final provider = MealPlanProvider();
    // Select an empty date so _EmptyMealPlan and the line 376 ElevatedButton are shown
    provider.selectDate(DateTime.now().add(const Duration(days: 8)));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MealPlanProvider>.value(value: provider),
          ChangeNotifierProvider<RecipeProvider>(
            create: (_) => RecipeProvider(recipeService: _FakeRecipeService()),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const MealPlanScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final addMealButton = find.widgetWithText(ElevatedButton, 'Add Meal');
    expect(addMealButton, findsOneWidget);

    // Tap the button and verify animation and response without assertion
    await tester.tap(addMealButton);
    await tester.pumpAndSettle();

    expect(find.text('Plan a Meal'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
