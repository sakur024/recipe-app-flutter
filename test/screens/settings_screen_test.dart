import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:recipe_app/core/constants/mock_data.dart';
import 'package:recipe_app/providers/favorites_provider.dart';
import 'package:recipe_app/providers/meal_plan_provider.dart';
import 'package:recipe_app/providers/settings_provider.dart';
import 'package:recipe_app/screens/settings/settings_screen.dart';

Widget _buildTestableSettingsScreen({
  required SettingsProvider settingsProvider,
  FavoritesProvider? favoritesProvider,
  MealPlanProvider? mealPlanProvider,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
      ChangeNotifierProvider<FavoritesProvider>.value(
        value: favoritesProvider ?? FavoritesProvider(),
      ),
      ChangeNotifierProvider<MealPlanProvider>.value(
        value: mealPlanProvider ?? MealPlanProvider(),
      ),
    ],
    child: const MaterialApp(
      home: SettingsScreen(),
    ),
  );
}

void main() {
  testWidgets('SettingsScreen renders guest profile without auth/login UI',
      (WidgetTester tester) async {
    final settings = SettingsProvider();
    await tester.pumpWidget(_buildTestableSettingsScreen(settingsProvider: settings));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Guest Chef'), findsOneWidget);
    expect(find.text('Cooking Enthusiast · Offline Profile'), findsOneWidget);

    // Explicitly verify NO login/auth/logout elements exist
    expect(find.text('Log In'), findsNothing);
    expect(find.text('Sign In'), findsNothing);
    expect(find.text('Register'), findsNothing);
    expect(find.text('Sign Up'), findsNothing);
    expect(find.text('Log Out'), findsNothing);
    expect(find.text('Sign Out'), findsNothing);
  });

  testWidgets('Toggling notifications updates SettingsProvider',
      (WidgetTester tester) async {
    final settings = SettingsProvider();
    await tester.pumpWidget(_buildTestableSettingsScreen(settingsProvider: settings));
    await tester.pumpAndSettle();

    expect(settings.notificationsEnabled, isTrue);

    // Find and tap the switch for push notifications
    final switches = find.byType(Switch);
    expect(switches, findsWidgets);

    await tester.tap(switches.first);
    await tester.pumpAndSettle();

    expect(settings.notificationsEnabled, isFalse);
  });

  testWidgets('Clear Favorites dialog clears favorites list',
      (WidgetTester tester) async {
    final settings = SettingsProvider();
    final favorites = FavoritesProvider();
    favorites.addFavorite(mockRecipes.first);
    expect(favorites.count, 1);

    await tester.pumpWidget(
      _buildTestableSettingsScreen(
        settingsProvider: settings,
        favoritesProvider: favorites,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Clear Favorites'));
    await tester.pumpAndSettle();

    expect(find.text('Clear Favorites?'), findsOneWidget);

    // Tap "Clear" in the dialog
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(favorites.count, 0);
  });

  testWidgets('Reset Meal Plan dialog clears planned meals',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final settings = SettingsProvider();
    final mealPlan = MealPlanProvider();
    expect(mealPlan.allItems.isNotEmpty, isTrue);

    await tester.pumpWidget(
      _buildTestableSettingsScreen(
        settingsProvider: settings,
        mealPlanProvider: mealPlan,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reset Meal Plan'));
    await tester.pumpAndSettle();

    expect(find.text('Reset Meal Plan?'), findsOneWidget);

    // Tap "Reset" in the dialog
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(mealPlan.allItems, isEmpty);
  });
}
