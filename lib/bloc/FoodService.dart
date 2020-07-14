import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/repository/food_repository.dart';

import 'package:rxdart/rxdart.dart';

class FoodService {
  final FoodRepository _foodRepository = FoodRepository();
  static List<Food> dbFoods;

  FoodService() {
    _getFoods();
  }

  void _getFoods() async {
    dbFoods = await _foodRepository.getAllFoods();
    _foodList.add(dbFoods);

    List<String> foodNamesFromDb;
    dbFoods.forEach((food) {
      foodNamesFromDb.add(food.name);
    });
    _foodNameList.add(foodNamesFromDb);
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

  remove(int id) async {
    _foodList.value.removeWhere((food) => food.id == id);
    _foodList.add(List<Food>.from(currentList));
    _foodRepository.deleteFoodById(id);

    // _foodNameList.value.removeAt(id);
    // _foodNameList.add(List<String>.from(currentListFoodName));

    _getFoods();
  }

  getFoodId(Food food) async {
    int id = await _foodRepository.getFoodId(food);
    return id;
  }

  update(Food food) async {
    print("PROTEIN ID:${food.id}");
    print("PROTEIN AMOUNT:${food..proteinAmount}");

    await _foodRepository.updateFood(food);
    _getFoods();
  }
}

FoodService foodListServices = FoodService();
