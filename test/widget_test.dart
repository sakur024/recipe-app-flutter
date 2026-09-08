import 'package:flutter_test/flutter_test.dart';

import 'package:recipe_app/main.dart';

void main() {
  testWidgets('Recipe app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeApp());

    expect(find.text('Home'), findsOneWidget);
  });
}