import 'dart:async';

import 'package:protein_tracker/db/database.dart';
import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/model/protein.dart';

class ProteinDao {
  final dbProvider = FoodDatabase.dbProvider;

  Future<int> createProtein(Protein protein) async {
    final db = await dbProvider.database;
    var result = db.insert(proteinTable, protein.toJson());
    return result;
  }

  Future<List<Protein>> getprotein({String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db
            .query(proteinTable, where: 'date LIKE ?', whereArgs: ["%$query%"]);
    } else {
      result = await db.query(proteinTable);
    }

    List<Protein> proteins = result.isNotEmpty
        ? result.map((item) => Protein.fromJson(item)).toList()
        : [];
    return proteins;
  }

  Future<int> updateProtein(Protein protein) async {
    final db = await dbProvider.database;

    var result = await db.update(proteinTable, protein.toJson(),
        where: "id = ?", whereArgs: [protein.id]);

    return result;
  }

  Future<int> getProteinId(Protein protein) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (protein != null) {
      result = await db.query(proteinTable,
          where: 'name = ?', whereArgs: ["${protein.name}"]);
    } else {
      result = await db.query(proteinTable);
    }
    Protein proteinfromDb = Protein.fromJson(result[0]);
    return proteinfromDb.id;
  }

  Future<int> deleteProtein(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(proteinTable, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future deleteAllProteins() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      proteinTable,
    );

    return result;
  }
}
