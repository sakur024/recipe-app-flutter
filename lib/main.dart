import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/favorites_provider.dart';
import 'screens/auth/auth_gate.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/firebase_service.dart';
import 'widgets/bottom_nav_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({
    super.key,
    this.home,
    this.authProvider,
    this.favoritesProvider,
  });

  final Widget? home;
  final AuthProvider? authProvider;
  final FavoritesProvider? favoritesProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        if (authProvider != null)
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider!)
        else
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        if (favoritesProvider != null)
          ChangeNotifierProvider<FavoritesProvider>.value(
            value: favoritesProvider!,
          )
        else
          ChangeNotifierProvider<FavoritesProvider>(
            create: (_) => FavoritesProvider(),
          ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: AppTheme.light,
        home: home ?? const AuthGate(),
      ),
    );
  }
}

/// Root shell that holds the current screen and bottom navigation.
///
/// Home and Favorites tabs are fully functional; Meal Plan remains a
/// placeholder, and Settings provides minimal account and logout actions.
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
          _PlaceholderTab(label: 'Meal Plan'),
          _SettingsTab(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

/// Minimal placeholder for tabs that are not yet implemented.
class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

/// Minimal settings screen providing account info and logout action.
class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final email = authProvider.currentUser?.email ?? 'User';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text('Settings', style: AppTextStyles.headingLarge),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusLarge,
                ),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: AppTextStyles.bodySecondary,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => context.read<AuthProvider>().logout(),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Log Out'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}