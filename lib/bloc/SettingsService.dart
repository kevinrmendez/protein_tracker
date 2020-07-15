import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/repository/food_repository.dart';

import 'package:rxdart/rxdart.dart';

class SettingsService {
  SettingsService() {
    initPreferences();
  }

  void initPreferences() {
    if (!preferences.containsKey("settings_weight")) {
      preferences.setInt("settings_weight", 0);
      print(preferences.getInt("settings_weight").toString());
      _weightSettings.add(0);
    } else {
      getWeightSettingsFromPreferences();
    }
  }

  void getWeightSettingsFromPreferences() async {
    int sharedPrefenrencesWeightSettings =
        preferences.getInt("settings_weight");
    print(
        "SHARED PREFERENCES WEIGHT SETTINGS  $sharedPrefenrencesWeightSettings");
    _weightSettings.add(sharedPrefenrencesWeightSettings);
  }

  //weight value is a boolean number 0 means false  setting value "lb" and 1 means true setting value "kg"
  BehaviorSubject<int> _weightSettings = BehaviorSubject.seeded(0);

  Stream get stream => _weightSettings.stream;

  int get currentWeightSettings => _weightSettings.value;

  updateWeightSettings(int weightSettings) async {
    _weightSettings.add(weightSettings);

    preferences.setInt("settings_weight", weightSettings);
  }
}

SettingsService settingsService = SettingsService();
