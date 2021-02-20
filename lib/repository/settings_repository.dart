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
}
