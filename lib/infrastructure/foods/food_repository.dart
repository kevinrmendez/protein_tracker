import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:protein_tracker/domain/foods/food.dart';
import 'package:protein_tracker/domain/foods/i_foods_repository.dart';
import 'package:protein_tracker/infrastructure/foods/food_entity.dart';

@LazySingleton()
@Injectable(as: IFoodRepository)
class FoodRepository implements IFoodRepository {
  @override
  Future<List<FoodEntity>> getAllFoods({String query}) {
    final Box<FoodEntity> box = Hive.box<FoodEntity>('foodEntity');
    print("Food BOX: VALUES");
    box.values.forEach((element) {
      print(element.name);
    });
    return Future.value(box.values.toList());
  }

  // Future getFoodId(Food food) => foodDao.getFoodId(food);
  @override
  void insertFood(FoodEntity food) {
    final Box<FoodEntity> box = Hive.box<FoodEntity>('foodEntity');
    box.put(food.id, food);
  }

  @override
  void updateFood(FoodEntity food) async {
    final Box<FoodEntity> box = Hive.box<FoodEntity>('foodEntity');
    await box.put(food.id, food);
  }

  void deleteFoodById(FoodEntity foodEntity) async {
    final Box<FoodEntity> box = Hive.box<FoodEntity>('foodEntity');
    await box.delete(foodEntity.id);
  }

  //We are not going to use this in the demo
  // Future deleteAllFoods() => foodDao.deleteAllFoods();
}
