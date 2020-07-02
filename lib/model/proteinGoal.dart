import 'package:rxdart/rxdart.dart';

class ProteinGoal {
  BehaviorSubject _proteinGoal = BehaviorSubject.seeded(0);

  Stream get stream => _proteinGoal.stream;
  int get current => _proteinGoal.value;

  setGoal(int goal) {
    _proteinGoal.add(goal);
  }
}

ProteinGoal proteinGoalServices = ProteinGoal();
