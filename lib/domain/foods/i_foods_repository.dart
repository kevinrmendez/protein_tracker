import 'package:protein_tracker/infrastructure/foods/food_entity.dart';

abstract class IFoodRepository {
  Future<List<FoodEntity>> getAllFoods();
  void insertFood(FoodEntity food);
  void updateFood(FoodEntity food);
  void deleteFoodById(FoodEntity food);
  //We are not going to use this in the demo
  // Future deleteAllFoods() => foodDao.deleteAllFoods();
}
