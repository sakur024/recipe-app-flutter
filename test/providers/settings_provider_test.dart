import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/providers/settings_provider.dart';

void main() {
  late SettingsProvider provider;

  setUp(() {
    provider = SettingsProvider();
  });

  group('SettingsProvider', () {
    test('initializes with sensible defaults', () {
      expect(provider.notificationsEnabled, isTrue);
      expect(provider.darkMode, isFalse);
      expect(provider.measurementUnit, 'Metric (g, ml)');
      expect(provider.dietaryPreference, 'Standard');
    });

    test('setNotificationsEnabled updates value and notifies listeners', () {
      int notifications = 0;
      provider.addListener(() => notifications++);

      provider.setNotificationsEnabled(false);
      expect(provider.notificationsEnabled, isFalse);
      expect(notifications, 1);

      // Same value does not redundantly notify
      provider.setNotificationsEnabled(false);
      expect(notifications, 1);
    });

    test('setDarkMode updates theme mode', () {
      provider.setDarkMode(true);
      expect(provider.darkMode, isTrue);
    });

    test('setMeasurementUnit updates measurement system', () {
      provider.setMeasurementUnit('Imperial (oz, cups)');
      expect(provider.measurementUnit, 'Imperial (oz, cups)');
    });

    test('setDietaryPreference updates diet', () {
      provider.setDietaryPreference('Vegetarian');
      expect(provider.dietaryPreference, 'Vegetarian');
    });

    test('resetToDefaults restores initial values', () {
      provider.setNotificationsEnabled(false);
      provider.setDarkMode(true);
      provider.setMeasurementUnit('Imperial (oz, cups)');
      provider.setDietaryPreference('Keto');

      provider.resetToDefaults();

      expect(provider.notificationsEnabled, isTrue);
      expect(provider.darkMode, isFalse);
      expect(provider.measurementUnit, 'Metric (g, ml)');
      expect(provider.dietaryPreference, 'Standard');
    });
  });
}
