import 'package:flutter/foundation.dart';

import '../models/recipe.dart';

/// Application-level provider managing the in-memory favorite recipes state.
///
/// Uses [ChangeNotifier] so UI widgets can listen to changes and rebuild.
/// Recipes are identified by [Recipe.name] to maintain uniqueness until
/// unique document IDs are introduced in a future milestone.
class FavoritesProvider extends ChangeNotifier {
  final List<Recipe> _favorites = [];

  /// An unmodifiable view of the currently favorited recipes.
  List<Recipe> get favorites => List.unmodifiable(_favorites);

  /// Number of currently favorited recipes.
  int get count => _favorites.length;

  /// Whether the favorites list is empty.
  bool get isEmpty => _favorites.isEmpty;

  /// Returns `true` if [recipe] is currently in the favorites list.
  bool isFavorite(Recipe recipe) {
    return _favorites.any((r) => r.name == recipe.name);
  }

  /// Adds [recipe] to favorites if it is not already present.
  void addFavorite(Recipe recipe) {
    if (!isFavorite(recipe)) {
      _favorites.add(recipe);
      notifyListeners();
    }
  }

  /// Removes [recipe] from favorites if present.
  void removeFavorite(Recipe recipe) {
    final originalLength = _favorites.length;
    _favorites.removeWhere((r) => r.name == recipe.name);
    if (_favorites.length != originalLength) {
      notifyListeners();
    }
  }

  /// Toggles favorite status for [recipe].
  void toggleFavorite(Recipe recipe) {
    if (isFavorite(recipe)) {
      removeFavorite(recipe);
    } else {
      addFavorite(recipe);
    }
  }

  /// Clears all favorited recipes.
  void clearFavorites() {
    if (_favorites.isNotEmpty) {
      _favorites.clear();
      notifyListeners();
    }
  }

  /// Convenience alias for [toggleFavorite].
  void toggle(Recipe recipe) => toggleFavorite(recipe);
}
