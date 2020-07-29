import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/repository/food_repository.dart';

import 'package:rxdart/rxdart.dart';

class FoodService {
  final FoodRepository _foodRepository = FoodRepository();
  static List<Food> dbFoods;

  BehaviorSubject<List<Food>> _foodList = BehaviorSubject.seeded([]);
  // BehaviorSubject.seeded([dbFoods] == null ? <List<Food>>[] : dbFoods);

  BehaviorSubject<List<String>> _foodNameList =
      BehaviorSubject.seeded(<String>[]);

  Stream get stream => _foodList.stream;
  Stream get streamFoodName => _foodNameList.stream;

  List<Food> get currentList => _foodList.value;
  List<String> get currentListFoodName => _foodNameList.value;

  FoodService() {
    _getFoods();
  }

  void _getFoods() async {
    dbFoods = await _foodRepository.getAllFoods();
    _foodList.add(dbFoods);

    //TODO: FIX SHOW DROPDOWN FOOD LIST VALUE ON DIALOG OPEN FOR FIRST TIME

    List<String> foodNamesFromDb = [];
    dbFoods.forEach((food) {
      foodNamesFromDb.add(food.name);
    });
    _foodNameList.add(foodNamesFromDb);
    print("foodNames added");
  }

  add(Food food) async {
    _foodRepository.insertFood(food);
    _foodList.value.add(food);
    _foodList.add(List<Food>.from(currentList));

    var allFoods = await _foodRepository.getAllFoods();
    allFoods.forEach((f) => print(f));

    _foodNameList.value.add(food.name);
    _foodNameList.add(List<String>.from(currentListFoodName));
    //TODO:FIX ADD REMOVE, UPDATE FOOD LIST WHEN 2 DIFFERENT DAYS ARE SHOWNED

    _getFoods();
  }

  remove(int id, int index) async {
    _foodList.value.removeWhere((food) => food.id == id);
    _foodList.add(List<Food>.from(currentList));
    _foodRepository.deleteFoodById(id);

    _foodNameList.value.removeAt(index);
    _foodNameList.add(List<String>.from(currentListFoodName));

    _getFoods();
  }

  getFoodId(Food food) async {
    int id = await _foodRepository.getFoodId(food);
    return id;
  }

  update(Food food) async {
    await _foodRepository.updateFood(food);
    _getFoods();
  }

  void orderFoodsAscending() {
    List<Food> orderList = currentList;
    orderList.sort((a, b) => a.name.compareTo(b.name));
    _foodList.add(orderList);
  }

  void orderFoodsDescending() {
    List<Food> orderList = currentList;
    orderList.sort((a, b) => a.name.compareTo(b.name));
    List<Food> reversedList = orderList.reversed.toList();
    _foodList.add(reversedList);
  }
}

FoodService foodListServices = FoodService();
