import 'dart:async';

import 'package:protein_tracker/db/database.dart';
import 'package:protein_tracker/model/food.dart';

class FoodDao {
  final dbProvider = FoodDatabase.dbProvider;

  Future<int> createFood(Food food) async {
    final db = await dbProvider.database;
    var result = db.insert(foodTable, food.toJson());
    return result;
  }

  Future<List<Food>> getfoods({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(foodTable,
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query(foodTable, columns: columns);
    }

    List<Food> foods = result.isNotEmpty
        ? result.map((item) => Food.fromJson(item)).toList()
        : [];
    return foods;
  }

  Future<int> getFoodId(Food food) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (food != null) {
      result = await db
          .query(foodTable, where: 'name = ?', whereArgs: ["${food.name}"]);
    } else {
      result = await db.query(foodTable);
    }
    Food foodfromDb = Food.fromJson(result[0]);
    return foodfromDb.id;
  }

  Future<int> updateFood(Food food) async {
    final db = await dbProvider.database;

    var result = await db.update(foodTable, food.toJson(),
        where: "id = ?", whereArgs: [food.id]);

    return result;
  }

  Future<int> deleteFood(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(foodTable, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future deleteAllFoods() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      foodTable,
    );

    return result;
  }
}
