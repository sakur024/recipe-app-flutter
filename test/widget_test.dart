import 'package:flutter_test/flutter_test.dart';

import 'package:recipe_app/main.dart';

void main() {
  testWidgets('App renders placeholder screen with app name',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeApp());

    // AppBar title and body heading both show the app name.
    expect(find.text('Recipe App'), findsNWidgets(2));
    expect(find.text('Design system ready'), findsOneWidget);
  });
}