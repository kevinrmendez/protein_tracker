import 'package:rxdart/rxdart.dart';

import 'food.dart';

class FoodService {
  BehaviorSubject<List<Food>> _foodList = BehaviorSubject.seeded(<Food>[]);

  Stream get stream => _foodList.stream;
  List<Food> get currentList => _foodList.value;

  add(Food food) {
    _foodList.value.add(food);
    _foodList.add(List<Food>.from(currentList));
  }
}

FoodService foodListServices = FoodService();
