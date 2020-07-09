import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/repository/food_repository.dart';

import 'package:rxdart/rxdart.dart';

class FoodService {
  final FoodRepository _foodRepository = FoodRepository();
  static List<Food> dbFoods = [];

  FoodService() {
    _getFoods();
  }

  void _getFoods() async {
    dbFoods = await _foodRepository.getAllFoods();
    _foodList.add(dbFoods);
  }

  BehaviorSubject<List<Food>> _foodList = BehaviorSubject.seeded([]);
  // BehaviorSubject.seeded([dbFoods] == null ? <List<Food>>[] : dbFoods);

  BehaviorSubject<List<String>> _foodNameList =
      BehaviorSubject.seeded(<String>[]);

  Stream get stream => _foodList.stream;
  Stream get streamFoodName => _foodNameList.stream;

  List<Food> get currentList => _foodList.value;
  List<String> get currentListFoodName => _foodNameList.value;

  add(Food food) async {
    _foodRepository.insertFood(food);
    _foodList.value.add(food);
    _foodList.add(List<Food>.from(currentList));

    var allFoods = await _foodRepository.getAllFoods();
    allFoods.forEach((f) => print(f));

    _foodNameList.value.add(food.name);
    _foodNameList.add(List<String>.from(currentListFoodName));
  }

  remove(int index) {
    _foodList.value.removeAt(index);
    _foodList.add(List<Food>.from(currentList));
    _foodRepository.deleteFoodById(index);

    _foodNameList.value.removeAt(index);
    _foodNameList.add(List<String>.from(currentListFoodName));
  }
}

FoodService foodListServices = FoodService();
