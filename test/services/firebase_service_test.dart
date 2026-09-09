import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/services/firebase_service.dart';

void main() {
  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseService.resetForTesting();
  });

  group('FirebaseService', () {
    test('starts with isInitialized false by default', () {
      expect(FirebaseService.isInitialized, isFalse);
    });

    test('handles initialization call gracefully without throwing unhandled exceptions', () async {
      // Calling initialize without configured credentials in test environment
      // should log notice, not crash the application, and remain uninitialized.
      await expectLater(FirebaseService.initialize(), completes);
      expect(FirebaseService.isInitialized, isFalse);
    });
  });
}
