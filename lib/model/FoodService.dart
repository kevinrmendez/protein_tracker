import 'package:rxdart/rxdart.dart';

import 'food.dart';

class FoodService {
  BehaviorSubject _foodList = BehaviorSubject.seeded([]);

  Stream get stream => _foodList.stream;
  List<Food> get currentList => _foodList.value;

  add(Food food) {
    _foodList.value.add(food);
    _foodList.add(List<Food>.from(currentList));
  }
}

FoodService foodListServices = FoodService();
