import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final foodTable = 'Food';
final proteinTable = 'Protein';
final dailyProteinTable = 'DailyProtein';

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
    await database.execute(
      "CREATE TABLE $dailyProteinTable(id INTEGER PRIMARY KEY  AUTOINCREMENT, date TEXT, totalProtein INTEGER, goal INTEGER, isGoalAchieved INTEGER DEFAULT 0)",
    );

    // await database.execute(
    //     "INSERT INTO $dailyProteinTable VALUES(10, '29-July-2020',100,80,1)");

    // await database.execute(
    //     "INSERT INTO $dailyProteinTable VALUES(11, '17-July-2020',100,80,1)");
    // await database.execute(
    //     "INSERT INTO $dailyProteinTable VALUES(12, '11-July-2020',100,80,1)");

    // await database.execute("INSERT INTO $foodTable VALUES(1, 'egg',6)");
    // await database
    //     .execute("INSERT INTO $foodTable VALUES(2, 'glass of milk',8)");
    // await database
    //     .execute("INSERT INTO $foodTable VALUES(3, 'chicken breast',54)");
    // await database.execute("INSERT INTO $foodTable VALUES(4, 'avocado',4)");
    // await database.execute("INSERT INTO $foodTable VALUES(5, 'peanuts',26)");
    // await database.execute("INSERT INTO $foodTable VALUES(6, 'soy yogurt',7)");
    // await database.execute("INSERT INTO $foodTable VALUES(7, 'ham',42)");

    // await database.execute(
    //     "INSERT INTO $proteinTable VALUES(17, 'mendez',70,'17-July-2020')");
    // await database.execute(
    //     "INSERT INTO $proteinTable VALUES(18, 'mendez',100,'18-July-2020')");
    // await database.execute(
    //     "INSERT INTO $proteinTable VALUES(19, 'mendez',90,'19-July-2020')");
    // await database.execute(
    //     "INSERT INTO $proteinTable VALUES(20, 'kevin',50,'20-July-2020')");
    // await database.execute(
    //     "INSERT INTO $proteinTable VALUES(21, 'ricardo',40,'21-July-2020')");
  }
}
