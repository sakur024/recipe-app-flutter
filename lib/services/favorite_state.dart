import 'package:flutter/foundation.dart';

import '../models/recipe.dart';

/// In-memory source of truth for the user's favorite recipes.
///
/// Uses [ChangeNotifier] so widgets can listen for updates.
/// This class is designed to be trivially wrapped in a
/// `ChangeNotifierProvider` when Provider is introduced.
///
/// Favorites are identified by [Recipe.name] to avoid requiring
/// an `id` field before Firestore is added. Once Firestore is
/// integrated, identification will switch to document IDs.
class FavoriteState extends ChangeNotifier {
  final Set<String> _favoriteNames = {};

  /// Unmodifiable view of the currently favorited recipe names.
  Set<String> get favoriteNames => Set.unmodifiable(_favoriteNames);

  /// Whether [recipe] is currently favorited.
  bool isFavorite(Recipe recipe) => _favoriteNames.contains(recipe.name);

  /// Adds or removes [recipe] from favorites.
  void toggle(Recipe recipe) {
    if (_favoriteNames.contains(recipe.name)) {
      _favoriteNames.remove(recipe.name);
    } else {
      _favoriteNames.add(recipe.name);
    }
    notifyListeners();
  }

  /// Returns only the recipes from [all] that are currently favorited,
  /// preserving list order.
  List<Recipe> filterFavorites(List<Recipe> all) {
    return all.where((r) => _favoriteNames.contains(r.name)).toList();
  }
}
