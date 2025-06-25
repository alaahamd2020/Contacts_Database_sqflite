import 'package:database_contacts/helper/constance.dart';
import 'package:database_contacts/model/userModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late Database _database;

  static Database get database => _database;

  DatabaseHelper._();

  static init() async {
    _database = await initDb();
  }

  // Future<Database> get database async {
  //   return _database ??= await initDb();
  // }

  static Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'UserData.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
      CREATE TABLE $tableUser (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnPhone TEXT NOT NULL,
      $columnEmail TEXT
      ) 
      ''');
      },
    );
  }

  Future<void> insert(UserModel user) async {
    var dbClinet = _database;
    await dbClinet.insert(
      tableUser,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUser(UserModel user) async {
    var dbClinet = _database;
    await dbClinet.update(
      tableUser,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: '$columnId = ?',
      whereArgs: [user.id],
    );
  }

  Future<UserModel?> getUser(int id) async {
    var dbClinet = _database;
    List<Map> maps = await dbClinet.query(
      tableUser,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? UserModel.fromJson(maps.first) : null;
  }

  Future<List<UserModel>> getAllUser() async {
    var dbClinet = _database;
    List<Map> users = await dbClinet.query(tableUser);
    return users.isNotEmpty
        ? users.map((user) => UserModel.fromJson(user)).toList()
        : [];
  }

  Future<int> deleteUser(int id) async {
    var dbClinet = _database;
    return dbClinet.delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
  }
}
