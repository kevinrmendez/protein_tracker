import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final foodTable = 'Food';
final proteinTable = 'Protein';

class FoodDatabase {
  static final FoodDatabase dbProvider = FoodDatabase();
  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //"ReactiveTodo.db is our database instance name
    String path = join(documentsDirectory.path, "food.db");
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $foodTable("
        "id INTEGER  PRIMARY KEY AUTOINCREMENT, "
        "name TEXT, "
        "proteinAmount INTEGER "
        ")");

    await database.execute("CREATE TABLE $proteinTable("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "name TEXT, "
        "amount INTEGER, "
        "date TEXT"
        ")");
    // await database.execute(
    //     "INSERT INTO $proteinTable VALUES(15, 'kevin',50,'15-July-2020')");
    // await database.execute(
    //     "INSERT INTO $proteinTable VALUES(16, 'ricardo',100,'16-July-2020')");
    // await database.execute(
    //     "INSERT INTO $proteinTable VALUES(17, 'mendez',200,'17-July-2020')");
  }
}
