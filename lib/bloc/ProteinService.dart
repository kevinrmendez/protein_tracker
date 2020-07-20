import 'package:protein_tracker/bloc/ProteinListService.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/model/goal.dart';
import 'package:rxdart/rxdart.dart';

class ProteinService {
  static Goal initGoal = Goal(preferences.getInt("protein_goal") ?? 1);
  BehaviorSubject<Goal> _proteinGoal = BehaviorSubject.seeded(initGoal);
  BehaviorSubject<int> _consumedProtein =
      BehaviorSubject.seeded(preferences.getInt("protein_consumed") ?? 0);

  Stream<Goal> get stream => _proteinGoal.stream;
  Stream get streamConsumedProtein => _consumedProtein.stream;

  Goal get current => _proteinGoal.value;
  int get currentConsumedProtein => _consumedProtein.value;

  ProteinService() {
    initPreferences();
  }
  void initPreferences() {
    if (!preferences.containsKey("protein_goal")) {
      Goal goal = Goal(1);
      preferences.setInt("protein_goal", goal.amount);
      print(preferences.getInt("protein_goal").toString());
      _proteinGoal.add(goal);
    } else {
      getProteinGoalFromPreferences();
    }
    if (!preferences.containsKey("protein_consumed")) {
      preferences.setInt("protein_consumed", 0);
      print(preferences.getInt("protein_consumed").toString());
    } else {
      getConsumedProteinFromPreferences();
    }
  }

  void getProteinGoalFromPreferences() async {
    int sharedPrefenrencesProteinGoal = preferences.getInt("protein_goal");
    print("SHARED PREFERENCES GOAL  $sharedPrefenrencesProteinGoal");
    Goal goalFromPreferences = Goal(sharedPrefenrencesProteinGoal);
    _proteinGoal.add(goalFromPreferences);
  }

  void getConsumedProteinFromPreferences() async {
    int sharedPrefenrencesConsumedProtein =
        preferences.getInt("protein_consumed");
    print("SHARED PREFERENCES PROTEIN $sharedPrefenrencesConsumedProtein");
    _consumedProtein.add(sharedPrefenrencesConsumedProtein);
  }

  setGoal(int goalAmount) {
    Goal goal = Goal(goalAmount);
    _proteinGoal.add(goal);
    preferences.setInt("protein_goal", goal.amount);
  }

  addConsumedProtein(int proteinAmount) {
    var proteinConsumed = currentConsumedProtein + proteinAmount;

    _consumedProtein.add(proteinConsumed);
    preferences.setInt("protein_consumed", proteinConsumed);
  }

  updateConsumedProtein() {
    var proteinConsumed = 0;
    List proteinList = proteinListServices.currentList;
    proteinList.forEach((p) {
      proteinConsumed = proteinConsumed + p.amount;
    });

    // var proteinConsumed = currentConsumedProtein + proteinAmount;
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

    if (updatedConsumedProtein < 0) {
      updatedConsumedProtein = 0;
    }
    _consumedProtein.add(updatedConsumedProtein);
    preferences.setInt("protein_consumed", updatedConsumedProtein);
  }
}

ProteinService proteinService = ProteinService();
