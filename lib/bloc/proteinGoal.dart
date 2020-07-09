import 'package:rxdart/rxdart.dart';

class ProteinService {
  BehaviorSubject _proteinGoal = BehaviorSubject.seeded(1);
  BehaviorSubject _consumedProtein = BehaviorSubject.seeded(0);

  Stream get stream => _proteinGoal.stream;
  Stream get streamConsumedProtein => _consumedProtein.stream;

  int get current => _proteinGoal.value;
  int get currentConsumedProtein => _consumedProtein.value;

  setGoal(int goal) {
    _proteinGoal.add(goal);
  }

  addConsumedProtein(int proteinAmount) {
    _consumedProtein.add(currentConsumedProtein + proteinAmount);
  }

  removeConsumedProtein(int proteinAmount) {
    _consumedProtein.add(currentConsumedProtein - proteinAmount);
  }
}

ProteinService proteinService = ProteinService();
