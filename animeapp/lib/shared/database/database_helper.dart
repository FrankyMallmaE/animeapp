import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:animeapp/feature/anime_list/data/anime_db_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'anime.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE anime(
            malId INTEGER PRIMARY KEY,
            title TEXT,
            imageUrl TEXT,
            year INTEGER,
            episodes INTEGER,
            members INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertAnime(AnimeDbModel anime) async {
    final db = await database;
    await db.insert('anime', anime.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<AnimeDbModel>> getAnimes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('anime');
    return List.generate(maps.length, (i) {
      return AnimeDbModel.fromJson(maps[i]);
    });
  }

  Future<void> deleteAnime(int malId) async {
    final db = await database;
    await db.delete('anime', where: 'malId = ?', whereArgs: [malId]);
  }
}