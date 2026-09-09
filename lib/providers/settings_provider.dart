import 'package:flutter/foundation.dart';

/// In-memory provider managing user preferences and application settings.
///
/// Designed to operate entirely locally without account or authentication
/// dependencies.
class SettingsProvider extends ChangeNotifier {
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  String _measurementUnit = 'Metric (g, ml)';
  String _dietaryPreference = 'Standard';

  /// Whether push/cooking notifications are enabled.
  bool get notificationsEnabled => _notificationsEnabled;

  /// Whether dark theme is enabled.
  bool get darkMode => _darkMode;

  /// Currently selected measurement units.
  String get measurementUnit => _measurementUnit;

  /// Currently selected dietary preference.
  String get dietaryPreference => _dietaryPreference;

  /// Toggles or sets notifications status.
  void setNotificationsEnabled(bool value) {
    if (_notificationsEnabled != value) {
      _notificationsEnabled = value;
      notifyListeners();
    }
  }

  /// Toggles or sets dark mode.
  void setDarkMode(bool value) {
    if (_darkMode != value) {
      _darkMode = value;
      notifyListeners();
    }
  }

  /// Sets measurement system ('Metric (g, ml)' or 'Imperial (oz, cups)').
  void setMeasurementUnit(String unit) {
    if (_measurementUnit != unit) {
      _measurementUnit = unit;
      notifyListeners();
    }
  }

  /// Sets dietary preference (e.g. 'Standard', 'Vegetarian', 'Vegan', 'Keto').
  void setDietaryPreference(String preference) {
    if (_dietaryPreference != preference) {
      _dietaryPreference = preference;
      notifyListeners();
    }
  }

  /// Resets preferences to defaults.
  void resetToDefaults() {
    _notificationsEnabled = true;
    _darkMode = false;
    _measurementUnit = 'Metric (g, ml)';
    _dietaryPreference = 'Standard';
    notifyListeners();
  }
}
