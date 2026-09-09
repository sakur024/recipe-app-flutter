import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/core/constants/mock_data.dart';
import 'package:recipe_app/models/meal_plan_item.dart';
import 'package:recipe_app/providers/meal_plan_provider.dart';

void main() {
  late MealPlanProvider provider;

  setUp(() {
    provider = MealPlanProvider();
  });

  group('MealPlanProvider', () {
    test('initializes with sample meals for today', () {
      expect(provider.allItems.isNotEmpty, isTrue);
      expect(provider.mealsForSelectedDate.isNotEmpty, isTrue);
    });

    test('selectDate updates selectedDate and filters meals accordingly', () {
      final futureDate = DateTime.now().add(const Duration(days: 10));
      provider.selectDate(futureDate);

      expect(provider.selectedDate.day, futureDate.day);
      expect(provider.mealsForSelectedDate, isEmpty);
    });

    test('addMeal adds a new planned meal and notifies listeners', () {
      final initialCount = provider.allItems.length;
      final targetDate = DateTime(2026, 10, 15);

      provider.addMeal(
        date: targetDate,
        mealType: MealType.dinner,
        recipe: mockRecipes.first,
      );

      expect(provider.allItems.length, initialCount + 1);
      final meals = provider.getMealsForDate(targetDate);
      expect(meals.length, 1);
      expect(meals.first.recipe.name, mockRecipes.first.name);
      expect(meals.first.mealType, MealType.dinner);
    });

    test('removeMeal deletes meal by ID', () {
      final initialMeals = provider.mealsForSelectedDate;
      expect(initialMeals.isNotEmpty, isTrue);
      final targetId = initialMeals.first.id;

      provider.removeMeal(targetId);

      expect(
        provider.mealsForSelectedDate.any((m) => m.id == targetId),
        isFalse,
      );
    });

    test('clearAll removes all planned meals across all dates', () {
      provider.clearAll();

      expect(provider.allItems, isEmpty);
      expect(provider.mealsForSelectedDate, isEmpty);
    });
  });
}
