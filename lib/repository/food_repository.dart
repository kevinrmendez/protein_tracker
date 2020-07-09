import 'package:protein_tracker/dao/food_dao.dart';
import 'package:protein_tracker/model/food.dart';

class FoodRepository {
  final foodDao = FoodDao();

  Future getAllFoods({String query}) => foodDao.getfoods(query: query);

  Future insertFood(Food food) => foodDao.createFood(food);

  Future updateFood(Food food) => foodDao.updateFood(food);

  Future deleteFoodById(int id) => foodDao.deleteFood(id);

  //We are not going to use this in the demo
  Future deleteAllFoods() => foodDao.deleteAllFoods();
}
