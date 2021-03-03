import 'package:injectable/injectable.dart';

import '../main.dart';
import 'dart:ui';

@LazySingleton()
class SettingsRepository {
  void changeLanguage(Locale locale) async {
    await preferences.setString('countryCode', locale.countryCode.toString());
    await preferences.setString('languageCode', locale.languageCode.toString());
  }

  Locale getLanguage() {
    if (!preferences.containsKey('countryCode')) {
      preferences.setString('countryCode', 'US');
    }
    if (!preferences.containsKey('languageCode')) {
      preferences.setString('languageCode', 'en');
    }
    var countryCode = preferences.getString('countryCode');
    var languageCode = preferences.getString('languageCode');
    return Locale(
      languageCode,
      countryCode,
    );
  }

  void changeDarkModeValue(bool isDarkModeEnabled) {
    preferences.setBool('isDarkModeEnabled', isDarkModeEnabled);
  }

  bool getDarkModeValue() {
    if (!preferences.containsKey('isDarkModeEnabled')) {
      preferences.setBool('isDarkModeEnabled', false);
    }
    return preferences.getBool('isDarkModeEnabled');
  }

  int getWeightUnit() {
    if (!preferences.containsKey('settings_weight')) {
      preferences.setInt("settings_weight", 0);
    }

    return preferences.getInt("settings_weight");
  }

  void changeWeightUnit(int weightSettings) {
    preferences.setInt("settings_weight", weightSettings);
  }
}
