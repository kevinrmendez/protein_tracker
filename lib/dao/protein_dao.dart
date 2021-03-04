import 'dart:async';

import 'package:hive/hive.dart';
import 'package:protein_tracker/db/database.dart';
import 'package:protein_tracker/model/protein_entity.dart';

class ProteinDao {
  final dbProvider = FoodDatabase.dbProvider;

  // Future<void> createProtein(Protein protein) async {
  //   final db = await dbProvider.database;

  //   db.insert(proteinTable, protein.toJson());

  //   // var result = db.insert(proteinTable, protein.toJson());
  //   // return result;
  // }
  Future<void> createProtein(ProteinEntity protein) async {
    final Box<ProteinEntity> box = Hive.box<ProteinEntity>('proteinEntity');

    box.put(protein.id, protein);
  }

  // Future<List<Protein>> getprotein({String query}) async {
  //   final db = await dbProvider.database;

  //   List<Map<String, dynamic>> result;
  //   if (query != null) {
  //     if (query.isNotEmpty)
  //       result = await db
  //           .query(proteinTable, where: 'date LIKE ?', whereArgs: ["%$query%"]);
  //   } else {
  //     result = await db.query(proteinTable);
  //   }

  //   List<Protein> proteins = result.isNotEmpty
  //       ? result.map((item) => Protein.fromJson(item)).toList()
  //       : [];
  //   return proteins;
  // }
  Future<List<ProteinEntity>> getprotein({String query}) async {
    final Box<ProteinEntity> box = Hive.box('proteinEntity');
    print("BOX: VALUES");

    box.values.forEach((element) {
      print(element.name);
    });
    return box.values.toList();
  }

  // Future<int> updateProtein(Protein protein) async {
  //   final db = await dbProvider.database;

  //   var result = await db.update(proteinTable, protein.toJson(),
  //       where: "id = ?", whereArgs: [protein.id]);

  //   return result;
  // }
  Future<void> updateProtein(ProteinEntity protein) async {
    final Box<ProteinEntity> box = Hive.box<ProteinEntity>('proteinEntity');
    await box.put(protein.id, protein);
    // final db = await dbProvider.database;

    // var result = await db.update(proteinTable, protein.toJson(),
    //     where: "id = ?", whereArgs: [protein.id]);

    // return result;
  }

  // Future<String> getProteinId(Protein protein) async {
  //   final db = await dbProvider.database;

  //   List<Map<String, dynamic>> result;
  //   if (protein != null) {
  //     result = await db.query(proteinTable,
  //         where: 'name = ?', whereArgs: ["${protein.name}"]);
  //   } else {
  //     result = await db.query(proteinTable);
  //   }
  //   Protein proteinfromDb = Protein.fromJson(result[0]);
  //   return proteinfromDb.id;
  // }

  // Future<int> deleteProtein(String id) async {
  //   final db = await dbProvider.database;
  //   var result =
  //       await db.delete(proteinTable, where: 'id = ?', whereArgs: [id]);

  //   return result;
  // }
  Future<void> deleteProtein(ProteinEntity proteinEntity) async {
    // var box = await Hive.openBox<ProteinEntity>('proteinEntity');
    final Box<ProteinEntity> box = Hive.box<ProteinEntity>('proteinEntity');
    await box.delete(proteinEntity.id);
    // await box.deleteAt(0);
    // await box.compact();
    // await box.close();

    // print('KEY TEST');
    // box.values.forEach((element) {
    //   print(element.id);
    // });
    // print(box.containsKey(proteinEntity));

    // final db = await dbProvider.database;
    // var result =
    //     await db.delete(proteinTable, where: 'id = ?', whereArgs: [id]);

    // return result;
  }

  // Future deleteAllProteins() async {
  //   final Box<ProteinEntity> box = Hive.box<ProteinEntity>('proteinEntity');
  //   final db = await dbProvider.database;
  //   var result = await db.delete(
  //     proteinTable,
  //   );

  //   return result;
  // }
}
