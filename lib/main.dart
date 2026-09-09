import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'providers/favorites_provider.dart';
import 'providers/meal_plan_provider.dart';
import 'providers/recipe_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/meal_plan/meal_plan_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'services/firebase_service.dart';
import 'services/firestore_seed.dart';
import 'widgets/bottom_nav_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();

  // One-time development seed execution
  if (kDebugMode && FirebaseService.isInitialized) {
    await FirestoreSeed.seedRecipes();
  }

  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({
    super.key,
    this.home,
    this.favoritesProvider,
    this.recipeProvider,
    this.mealPlanProvider,
    this.settingsProvider,
  });

  final Widget? home;
  final FavoritesProvider? favoritesProvider;
  final RecipeProvider? recipeProvider;
  final MealPlanProvider? mealPlanProvider;
  final SettingsProvider? settingsProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        if (favoritesProvider != null)
          ChangeNotifierProvider<FavoritesProvider>.value(
            value: favoritesProvider!,
          )
        else
          ChangeNotifierProvider<FavoritesProvider>(
            create: (_) => FavoritesProvider(),
          ),
        if (recipeProvider != null)
          ChangeNotifierProvider<RecipeProvider>.value(
            value: recipeProvider!,
          )
        else
          ChangeNotifierProvider<RecipeProvider>(
            create: (_) => RecipeProvider(),
          ),
        if (mealPlanProvider != null)
          ChangeNotifierProvider<MealPlanProvider>.value(
            value: mealPlanProvider!,
          )
        else
          ChangeNotifierProvider<MealPlanProvider>(
            create: (_) => MealPlanProvider(),
          ),
        if (settingsProvider != null)
          ChangeNotifierProvider<SettingsProvider>.value(
            value: settingsProvider!,
          )
        else
          ChangeNotifierProvider<SettingsProvider>(
            create: (_) => SettingsProvider(),
          ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
            home: home ?? const MainShell(),
          );
        },
      ),
    );
  }
}

/// Root shell that holds the current screen and bottom navigation.
///
/// All four tabs (Home, Favorites, Meal Plan, Settings) are fully
/// functional and state-synchronized.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          FavoritesScreen(),
          MealPlanScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}