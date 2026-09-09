import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';

/// Foundation service for Firebase infrastructure.
///
/// Centralizes initialization and status checking for Firebase services.
class FirebaseService {
  FirebaseService._();

  static bool _isInitialized = false;

  /// Whether Firebase was successfully initialized.
  static bool get isInitialized => _isInitialized;

  /// Initializes the default Firebase application using [DefaultFirebaseOptions.currentPlatform].
  ///
  /// Accepts optional [FirebaseOptions] for testing or custom configuration.
  /// If configuration options are absent or initialization fails, errors
  /// are logged with full details rather than hidden.
  static Future<void> initialize({FirebaseOptions? options}) async {
    try {
      if (Firebase.apps.isEmpty) {
        final resolvedOptions =
            options ?? DefaultFirebaseOptions.currentPlatform;
        await Firebase.initializeApp(options: resolvedOptions);
      }
      _isInitialized = true;
      debugPrint('[FirebaseService] Firebase initialized successfully.');
    } catch (e, stackTrace) {
      _isInitialized = false;
      debugPrint('[FirebaseService] Firebase initialization notice: $e');
      debugPrint('[FirebaseService] StackTrace: $stackTrace');
    }
  }

  /// Reset internal state (primarily used for unit testing).
  @visibleForTesting
  static void resetForTesting() {
    _isInitialized = false;
  }
}
