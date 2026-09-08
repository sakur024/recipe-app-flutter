import 'package:flutter_test/flutter_test.dart';

import 'package:recipe_app/main.dart';

void main() {
  testWidgets('App renders Home screen with key sections',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeApp());

    // Header greeting is visible.
    expect(find.textContaining('cooking today'), findsOneWidget);

    // Search bar hint is visible.
    expect(find.text('Search recipes'), findsOneWidget);

    // Category section is visible.
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);

    // Quick & Easy section is visible.
    expect(find.text('Quick & Easy'), findsOneWidget);

    // Bottom navigation items are visible.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Meal Plan'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}