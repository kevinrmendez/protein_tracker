import 'package:protein_tracker/bloc/ProteinListService.dart';
import 'package:protein_tracker/main.dart';
import 'package:rxdart/rxdart.dart';

class ProteinService {
  BehaviorSubject _proteinGoal = BehaviorSubject.seeded(1);
  BehaviorSubject _consumedProtein = BehaviorSubject.seeded(0);

  Stream get stream => _proteinGoal.stream;
  Stream get streamConsumedProtein => _consumedProtein.stream;

  int get current => _proteinGoal.value;
  int get currentConsumedProtein => _consumedProtein.value;

  ProteinService() {
    initPreferences();
  }
  void initPreferences() {
    if (!preferences.containsKey("protein_goal")) {
      preferences.setInt("protein_goal", 1);
      _proteinGoal.add(1);
    } else {
      getProteinGoalFromPreferences();
    }
    if (!preferences.containsKey("protein_consumed")) {
      preferences.setInt("protein_consumed", 0);
    } else {
      getConsumedProteinFromPreferences();
    }
  }

  void getProteinGoalFromPreferences() async {
    int sharedPrefenrencesProteinGoal = preferences.getInt("protein_goal");
    print("SHARED PREFERENCES GOAL  $sharedPrefenrencesProteinGoal");
    _proteinGoal.add(sharedPrefenrencesProteinGoal);
  }

  void getConsumedProteinFromPreferences() async {
    int sharedPrefenrencesConsumedProtein =
        preferences.getInt("protein_consumed");
    print("SHARED PREFERENCES PROTEIN $sharedPrefenrencesConsumedProtein");
    _proteinGoal.add(sharedPrefenrencesConsumedProtein);
  }

  setGoal(int goal) {
    _proteinGoal.add(goal);
    preferences.setInt("protein_goal", goal);
  }

  addConsumedProtein(int proteinAmount) {
    var proteinConsumed = currentConsumedProtein + proteinAmount;

    _consumedProtein.add(proteinConsumed);
    preferences.setInt("protein_consumed", proteinConsumed);
  }

  resetConsumedProtein() {
    _consumedProtein.add(0);
    preferences.setInt("protein_consumed", 0);
    print(preferences.getInt("protein_consumed"));
    print("${proteinService.currentConsumedProtein}");
  }

  removeConsumedProtein(int proteinAmount) {
    var updatedConsumedProtein = currentConsumedProtein - proteinAmount;
    _consumedProtein.add(updatedConsumedProtein);
    preferences.setInt("protein_consumed", updatedConsumedProtein);
  }
}

ProteinService proteinService = ProteinService();
