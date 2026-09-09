import 'package:flutter/foundation.dart';

import '../core/constants/mock_data.dart';
import '../models/meal_plan_item.dart';
import '../models/recipe.dart';

/// Provider for managing in-memory weekly meal plans.
///
/// Keeps meals organized by date and meal type. Does not persist
/// to cloud, adhering to local-only scope.
class MealPlanProvider extends ChangeNotifier {
  MealPlanProvider() {
    _initSampleData();
  }

  final List<MealPlanItem> _items = [];
  DateTime _selectedDate = _normalizeDate(DateTime.now());

  /// Currently selected calendar date (normalized to midnight).
  DateTime get selectedDate => _selectedDate;

  /// All planned meal items.
  List<MealPlanItem> get allItems => List.unmodifiable(_items);

  /// Planned meals for the currently selected date.
  List<MealPlanItem> get mealsForSelectedDate => getMealsForDate(_selectedDate);

  /// Helper to strip time components from a [DateTime].
  static DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Changes the active calendar date and notifies listeners.
  void selectDate(DateTime date) {
    final normalized = _normalizeDate(date);
    if (_selectedDate != normalized) {
      _selectedDate = normalized;
      notifyListeners();
    }
  }

  /// Returns all meals planned for [date].
  List<MealPlanItem> getMealsForDate(DateTime date) {
    final normalized = _normalizeDate(date);
    return _items
        .where((item) => _normalizeDate(item.date) == normalized)
        .toList();
  }

  /// Adds a new planned meal.
  void addMeal({
    required DateTime date,
    required MealType mealType,
    required Recipe recipe,
  }) {
    final item = MealPlanItem(
      id: '${date.millisecondsSinceEpoch}_${recipe.name}_${mealType.name}',
      date: _normalizeDate(date),
      mealType: mealType,
      recipe: recipe,
    );
    _items.add(item);
    notifyListeners();
  }

  /// Removes a planned meal by its [id].
  void removeMeal(String id) {
    final beforeCount = _items.length;
    _items.removeWhere((item) => item.id == id);
    if (_items.length != beforeCount) {
      notifyListeners();
    }
  }

  /// Clears all planned meals.
  void clearAll() {
    if (_items.isNotEmpty) {
      _items.clear();
      notifyListeners();
    }
  }

  /// Populates 2 initial sample meals for today and tomorrow.
  void _initSampleData() {
    if (mockRecipes.length >= 2) {
      final today = _normalizeDate(DateTime.now());
      _items.add(
        MealPlanItem(
          id: 'sample_today_breakfast',
          date: today,
          mealType: MealType.breakfast,
          recipe: mockRecipes[1], // French Toast
        ),
      );
      _items.add(
        MealPlanItem(
          id: 'sample_today_dinner',
          date: today,
          mealType: MealType.dinner,
          recipe: mockRecipes[0], // Mexican Pizza
        ),
      );
    }
  }
}
