import 'dart:async';

import 'package:hive/hive.dart';
import 'package:protein_tracker/db/database.dart';
import 'package:protein_tracker/model/foods/food_entity.dart';

class FoodDao {
  final dbProvider = FoodDatabase.dbProvider;

  Future<void> createFood(FoodEntity food) async {
    final Box<FoodEntity> box = Hive.box<FoodEntity>('foodEntity');
    box.put(food.id, food);
  }

  Future<List<FoodEntity>> getfoods({String query}) async {
    final Box<FoodEntity> box = Hive.box<FoodEntity>('foodEntity');
    print("BOX: VALUES");
    box.values.forEach((element) {
      print(element.name);
    });
    return box.values.toList();
  }

  Future<void> updateFood(FoodEntity food) async {
    final Box<FoodEntity> box = Hive.box<FoodEntity>('foodEntity');
    await box.put(food.id, food);
  }

  Future<void> deleteFood(FoodEntity foodEntity) async {
    final Box<FoodEntity> box = Hive.box<FoodEntity>('foodEntity');
    await box.delete(foodEntity.id);
  }

  // Future deleteAllFoods() async {
  //   final db = await dbProvider.database;
  //   var result = await db.delete(
  //     foodTable,
  //   );

  //   return result;
  // }
}
