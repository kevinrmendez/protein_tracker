import 'package:injectable/injectable.dart';
import 'package:protein_tracker/dao/food_dao.dart';
import 'package:protein_tracker/model/foods/food.dart';
import 'package:protein_tracker/model/foods/food_entity.dart';

@LazySingleton()
class FoodRepository {
  final foodDao = FoodDao();

  Future<List<FoodEntity>> getAllFoods({String query}) =>
      foodDao.getfoods(query: query);

  // Future getFoodId(Food food) => foodDao.getFoodId(food);

  Future insertFood(FoodEntity food) => foodDao.createFood(food);

  Future updateFood(FoodEntity food) => foodDao.updateFood(food);

  Future deleteFoodById(FoodEntity food) => foodDao.deleteFood(food);

  //We are not going to use this in the demo
  // Future deleteAllFoods() => foodDao.deleteAllFoods();
}
