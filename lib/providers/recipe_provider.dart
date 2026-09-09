import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/recipe.dart';
import '../services/recipe_service.dart';

/// Provider managing the application's recipe list state.
///
/// Uses [ChangeNotifier] so UI widgets can reactively rebuild when
/// recipes are loaded, refresh, or encounter errors.
///
/// Data flow: UI → [RecipeProvider] → [RecipeService] → Firestore.
class RecipeProvider extends ChangeNotifier {
  RecipeProvider({RecipeService? recipeService})
      : _recipeService = recipeService ?? RecipeService();

  final RecipeService _recipeService;

  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String? _errorMessage;

  /// The current list of recipes from Firestore.
  List<Recipe> get recipes => List.unmodifiable(_recipes);

  /// Whether a recipe fetch operation is in progress.
  bool get isLoading => _isLoading;

  /// Active error message, if any, from the last fetch attempt.
  String? get errorMessage => _errorMessage;

  /// Whether recipes have been loaded successfully at least once.
  bool get hasData => _recipes.isNotEmpty;

  /// Loads all recipes from Firestore via [RecipeService].
  ///
  /// Sets [isLoading] to `true` while the operation is in progress,
  /// and populates [errorMessage] on failure.
  Future<void> loadRecipes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _recipes = await _recipeService.fetchAllRecipes();
      _isLoading = false;
      notifyListeners();
    } on FirebaseException catch (e) {
      _isLoading = false;
      debugPrint('[RecipeProvider] Firestore error: [${e.code}] ${e.message}');
      if (e.code == 'permission-denied') {
        _errorMessage =
            'Permission denied. Firestore security rules must allow public reads.';
      } else if (e.code == 'failed-precondition') {
        _errorMessage =
            'Firestore database has not been created in this Firebase project.';
      } else if (e.code == 'unavailable') {
        _errorMessage =
            'Firestore service is unavailable. Check your network connection.';
      } else if (e.code == 'not-found') {
        _errorMessage = 'Firestore collection or database not found.';
      } else if (e.code == 'no-app') {
        _errorMessage = 'Firebase is not initialized.';
      } else {
        _errorMessage =
            'Firestore error (${e.code}): ${e.message ?? 'Unknown error'}';
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Unable to load recipes. Please try again.';
      debugPrint('[RecipeProvider] Error loading recipes: $e');
      notifyListeners();
    }
  }

  /// Convenience alias that clears the current list and reloads.
  Future<void> refreshRecipes() async {
    await loadRecipes();
  }
}
