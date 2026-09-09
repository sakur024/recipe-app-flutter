import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/recipe.dart';
import 'firebase_service.dart';

/// Service encapsulating all Firestore recipe operations.
///
/// Direct Firestore calls are isolated here, keeping UI widgets
/// and providers decoupled from SDK internals. Accepts an optional
/// [FirebaseFirestore] instance for dependency injection in tests.
class RecipeService {
  RecipeService({FirebaseFirestore? firestore}) : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  /// Lazily resolves the Firestore instance. Falls back to the default
  /// singleton only when actually needed (not during construction), so
  /// test fakes that override all methods never trigger this path.
  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  /// Reference to the `recipes` collection.
  CollectionReference<Map<String, dynamic>> get _recipesRef =>
      _db.collection('recipes');

  /// Fetches all recipes from Firestore.
  ///
  /// Malformed documents are skipped with a debug log rather than
  /// crashing the entire recipe list.
  Future<List<Recipe>> fetchAllRecipes() async {
    if (_firestore == null &&
        (Firebase.apps.isEmpty || !FirebaseService.isInitialized)) {
      debugPrint(
        '[RecipeService] Firebase is not initialized. '
        'Firebase.apps.isNotEmpty=${Firebase.apps.isNotEmpty}, '
        'FirebaseService.isInitialized=${FirebaseService.isInitialized}.',
      );
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'no-app',
        message: 'Firebase is not initialized. Please ensure FirebaseCore initializes properly.',
      );
    }

    try {
      debugPrint('[RecipeService] Querying Firestore collection "recipes"...');
      final snapshot = await _recipesRef.get();
      debugPrint(
        '[RecipeService] Firestore query returned ${snapshot.docs.length} documents.',
      );
      final recipes = <Recipe>[];

      for (final doc in snapshot.docs) {
        try {
          final data = doc.data();
          recipes.add(Recipe.fromMap(data, doc.id));
        } catch (e) {
          debugPrint(
            '[RecipeService] Skipping malformed document ${doc.id}: $e',
          );
        }
      }

      return recipes;
    } on FirebaseException catch (e, stackTrace) {
      debugPrint('[RecipeService] Firestore FirebaseException caught:');
      debugPrint('  Plugin: ${e.plugin}');
      debugPrint('  Code: ${e.code}');
      debugPrint('  Message: ${e.message}');
      debugPrint('StackTrace: $stackTrace');
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('[RecipeService] Unexpected error fetching recipes: $e');
      debugPrint('StackTrace: $stackTrace');
      rethrow;
    }
  }

  /// Fetches a single recipe by its Firestore document [id].
  ///
  /// Returns `null` if the document does not exist.
  Future<Recipe?> fetchRecipeById(String id) async {
    if (_firestore == null &&
        (Firebase.apps.isEmpty || !FirebaseService.isInitialized)) {
      debugPrint('[RecipeService] Firebase is not initialized.');
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'no-app',
        message: 'Firebase is not initialized.',
      );
    }

    try {
      final doc = await _recipesRef.doc(id).get();
      if (!doc.exists || doc.data() == null) return null;
      return Recipe.fromMap(doc.data()!, doc.id);
    } on FirebaseException catch (e, stackTrace) {
      debugPrint('[RecipeService] Firestore FirebaseException for $id:');
      debugPrint('  Plugin: ${e.plugin}');
      debugPrint('  Code: ${e.code}');
      debugPrint('  Message: ${e.message}');
      debugPrint('StackTrace: $stackTrace');
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('[RecipeService] Failed to fetch recipe $id: $e');
      debugPrint('StackTrace: $stackTrace');
      rethrow;
    }
  }
}
