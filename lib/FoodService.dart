import 'package:protein_tracker/model/food.dart';
import 'package:rxdart/rxdart.dart';

class FoodService {
  BehaviorSubject<List<Food>> _foodList = BehaviorSubject.seeded(<Food>[]);
  BehaviorSubject<List<String>> _foodNameList =
      BehaviorSubject.seeded(<String>[""]);

  Stream get stream => _foodList.stream;
  Stream get streamFoodName => _foodNameList.stream;

  List<Food> get currentList => _foodList.value;
  List<String> get currentListFoodName => _foodNameList.value;

  add(Food food) {
    _foodList.value.add(food);
    _foodList.add(List<Food>.from(currentList));

    _foodNameList.value.add(food.name);
    _foodNameList.add(List<String>.from(currentListFoodName));
  }

  remove(int index) {
    _foodList.value.removeAt(index);
    _foodList.add(List<Food>.from(currentList));

    _foodNameList.value.removeAt(index);
    _foodNameList.add(List<String>.from(currentListFoodName));
  }
}

FoodService foodListServices = FoodService();
