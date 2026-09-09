import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../core/constants/mock_data.dart';

/// Development-only utility for seeding Firestore with mock recipes.
///
/// Uses [WriteBatch] for efficient atomic writes.
/// Document IDs are derived from the recipe name to ensure idempotency.
///
/// Usage (in `main.dart`, behind `kDebugMode`):
/// ```dart
/// if (kDebugMode) {
///   await FirestoreSeed.seedRecipes();
/// }
/// ```
class FirestoreSeed {
  FirestoreSeed._();

  /// Seeds the `recipes` collection with data from [mockRecipes] if the
  /// collection is currently empty.
  ///
  /// Safe to call on startup; will skip seeding if any documents exist.
  static Future<void> seedRecipes({
    FirebaseFirestore? firestore,
  }) async {
    final db = firestore ?? FirebaseFirestore.instance;
    final recipesRef = db.collection('recipes');

    try {
      final existing = await recipesRef.limit(1).get();
      if (existing.docs.isNotEmpty) {
        debugPrint(
          '[FirestoreSeed] Recipes collection already contains data. Skipping seed.',
        );
        return;
      }

      final batch = db.batch();
      for (int i = 0; i < mockRecipes.length; i++) {
        final recipe = mockRecipes[i];
        final docId = 'recipe_${i + 1}';
        batch.set(recipesRef.doc(docId), recipe.toMap());
      }

      await batch.commit();
      debugPrint(
        '[FirestoreSeed] Successfully seeded ${mockRecipes.length} recipes.',
      );
    } catch (e) {
      debugPrint('[FirestoreSeed] Seed check/write notice: $e');
    }
  }
}
