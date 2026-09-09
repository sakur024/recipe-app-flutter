import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/settings_provider.dart';

/// Application settings and local preferences screen.
///
/// Operates entirely locally with no external account or authentication
/// dependencies.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.pagePadding,
                vertical: 16,
              ),
              children: [
                // ── Screen Title ─────────────────────────────────
                Text('Settings', style: AppTextStyles.headingLarge),
                const SizedBox(height: 20),

                // ── Profile Section (No Auth / Local Profile) ────
                _buildProfileCard(context),
                const SizedBox(height: 24),

                // ── Preferences Section ──────────────────────────
                _buildSectionHeader('Preferences'),
                const SizedBox(height: 10),
                _buildCardContainer([
                  SwitchListTile(
                    title: Text(
                      'Push Notifications',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Reminders for meal cooking & planning',
                      style: AppTextStyles.label,
                    ),
                    secondary: const Icon(
                      Icons.notifications_active_outlined,
                      color: AppColors.primary,
                    ),
                    value: settings.notificationsEnabled,
                    onChanged: (val) => settings.setNotificationsEnabled(val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(
                      'Dark Mode',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Adjust appearance for low light',
                      style: AppTextStyles.label,
                    ),
                    secondary: const Icon(
                      Icons.dark_mode_outlined,
                      color: AppColors.primary,
                    ),
                    value: settings.darkMode,
                    onChanged: (val) => settings.setDarkMode(val),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.straighten_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      'Measurement Units',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      settings.measurementUnit,
                      style: AppTextStyles.label,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () => _showUnitPicker(context, settings),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.restaurant_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      'Dietary Preference',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      settings.dietaryPreference,
                      style: AppTextStyles.label,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () => _showDietaryPicker(context, settings),
                  ),
                ]),

                const SizedBox(height: 24),

                // ── Data Management Section ──────────────────────
                _buildSectionHeader('Data Management'),
                const SizedBox(height: 10),
                _buildCardContainer([
                  ListTile(
                    leading: const Icon(
                      Icons.favorite_border_rounded,
                      color: AppColors.error,
                    ),
                    title: Text(
                      'Clear Favorites',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Remove all recipes from your favorites list',
                      style: AppTextStyles.label,
                    ),
                    onTap: () => _confirmClearFavorites(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.error,
                    ),
                    title: Text(
                      'Reset Meal Plan',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Remove all planned meals for all dates',
                      style: AppTextStyles.label,
                    ),
                    onTap: () => _confirmResetMealPlan(context),
                  ),
                ]),

                const SizedBox(height: 24),

                // ── About & Info Section ─────────────────────────
                _buildSectionHeader('About'),
                const SizedBox(height: 10),
                _buildCardContainer([
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      'About Recipe App',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: const Text(
                      'A mobile cookbook & meal planner',
                      style: AppTextStyles.label,
                    ),
                    onTap: () => _showAboutDialog(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.policy_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      'Open Source Licenses',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationName: AppConstants.appName,
                        applicationVersion: '1.0.0+1',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.verified_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      'App Version',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      'v1.0.0+1',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ]),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Guest Chef',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Local',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Cooking Enthusiast · Offline Profile',
                  style: AppTextStyles.bodySecondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.headingSmall.copyWith(fontSize: 16),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  void _showUnitPicker(BuildContext context, SettingsProvider settings) {
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Measurement Units'),
        children: [
          ListTile(
            title: const Text('Metric (g, ml, °C)'),
            trailing: settings.measurementUnit == 'Metric (g, ml)'
                ? const Icon(Icons.check_rounded, color: AppColors.primary)
                : null,
            onTap: () {
              settings.setMeasurementUnit('Metric (g, ml)');
              Navigator.of(ctx).pop();
            },
          ),
          ListTile(
            title: const Text('Imperial (oz, cups, °F)'),
            trailing: settings.measurementUnit == 'Imperial (oz, cups)'
                ? const Icon(Icons.check_rounded, color: AppColors.primary)
                : null,
            onTap: () {
              settings.setMeasurementUnit('Imperial (oz, cups)');
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showDietaryPicker(BuildContext context, SettingsProvider settings) {
    final options = ['Standard', 'Vegetarian', 'Vegan', 'Keto', 'Gluten-Free'];
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Dietary Preference'),
        children: options.map((opt) {
          final isSelected = opt == settings.dietaryPreference;
          return ListTile(
            title: Text(opt),
            trailing: isSelected
                ? const Icon(Icons.check_rounded, color: AppColors.primary)
                : null,
            onTap: () {
              settings.setDietaryPreference(opt);
              Navigator.of(ctx).pop();
            },
          );
        }).toList(),
      ),
    );
  }

  void _confirmClearFavorites(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Favorites?'),
        content: const Text(
          'This will remove all saved recipes from your favorites list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<FavoritesProvider>().clearFavorites();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Favorites have been cleared.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmResetMealPlan(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Meal Plan?'),
        content: const Text(
          'This will remove all planned meals for all dates.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<MealPlanProvider>().clearAll();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Meal plan has been reset.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('About Recipe App'),
        content: const Text(
          'Recipe App is your all-in-one culinary companion. Discover delicious '
          'recipes, manage your favorites, and plan your weekly meals with ease.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
