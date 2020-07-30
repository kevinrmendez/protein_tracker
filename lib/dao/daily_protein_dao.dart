import 'dart:async';

import 'package:protein_tracker/db/database.dart';
import 'package:protein_tracker/model/dailyProtein.dart';

class DailyProteinDao {
  final dbProvider = FoodDatabase.dbProvider;

  Future<int> createDailyProtein(DailyProtein dailyProtein) async {
    final db = await dbProvider.database;
    var result = db.insert(dailyProteinTable, dailyProtein.toJson());
    return result;
  }

  Future<List<DailyProtein>> getDailyProtein({String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(dailyProteinTable,
            where: 'date LIKE ?', whereArgs: ["%$query%"]);
    } else {
      result = await db.query(dailyProteinTable);
    }

    List<DailyProtein> dailyProteins = result.isNotEmpty
        ? result.map((item) => DailyProtein.fromJson(item)).toList()
        : [];
    return dailyProteins;
  }

  Future<int> updateDailyProtein(DailyProtein dailyProtein) async {
    final db = await dbProvider.database;

    var result = await db.update(dailyProteinTable, dailyProtein.toJson(),
        where: "id = ?", whereArgs: [dailyProtein.id]);

    return result;
  }

  Future<int> getDailyDailyProteinId(DailyProtein dailyProtein) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (dailyProtein != null) {
      result = await db.query(dailyProteinTable,
          where: 'date = ?', whereArgs: ["${dailyProtein.date}"]);
    } else {
      result = await db.query(dailyProteinTable);
    }
    if (result == null || result.length == 0) {
      return null;
    } else {
      DailyProtein dailyProteinfromDb = DailyProtein.fromJson(result[0]);
      return dailyProteinfromDb.id;
    }
  }

  Future<int> deleteDailyProtein(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(dailyProteinTable, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future deleteAllDailyProteins() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      dailyProteinTable,
    );

    return result;
  }

  Future<int> getDailyDailyProteinIdByDate(String date) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (date != null) {
      result = await db
          .query(dailyProteinTable, where: 'date = ?', whereArgs: ["$date"]);
    } else {
      result = await db.query(dailyProteinTable);
    }
    if (result == null || result.isEmpty) {
      return null;
    } else {
      DailyProtein dailyProteinfromDb = DailyProtein.fromJson(result[0]);
      return dailyProteinfromDb.id;
    }
  }
}
