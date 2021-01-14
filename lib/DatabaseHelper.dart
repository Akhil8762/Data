import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Data.dart';

class DatabaseHelper {
  DatabaseHelper._(); // create private constructor
  static const DatabaseName = 'database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database;
  }

  initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), DatabaseName),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE datatable(id INTEGER PRIMARY KEY NOT NULL,name TEXT,job TEXT)");
    });
  }

// insert into table
  insertdata(Data data) async {
    final db = await database;
    var res = await db.insert('datatable', data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  // retrive data
  // adding data to list
  Future<List<Data>> retrieveData() async {
    final db = await database;

// adding datas into the variable named 'maps'
    final List<Map<String, dynamic>> maps = await db.query('datatable');

    return List.generate(maps.length, (i) {
      return Data(
        id: maps[i]['id'],
        name: maps[i]['name'],
        job: maps[i]['job'],
      );
    });
  }

  updatedata(Data data) async {
    final db = await database;
    await db.update('datatable', data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  deletedata(int id) async {
    var db = await database;
    db.delete('datatable', where: 'id = ?', whereArgs: [id]);
  }
}
