import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/fav_pokemon.dart';

class FavPokemonDB {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'fav_pokemons.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE fav_pokemons (
        id INTEGER PRIMARY KEY,
        name TEXT,
        nickname TEXT,
        imgUrl TEXT
      )
    ''');
  }

  Future<void> insert(FavPokemon pokemon) async {
    final Database db = await database;
    await db.insert(
      'fav_pokemons',
      pokemon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(FavPokemon pokemon) async {
    final Database db = await database;
    await db.delete(
      'fav_pokemons',
      where: 'id = ?',
      whereArgs: [pokemon.id],
    );
  }

  Future<List<FavPokemon>> getAll() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('fav_pokemons');
    return List.generate(maps.length, (i) {
      return FavPokemon(
        id: maps[i]['id'],
        name: maps[i]['name'],
        nickname: maps[i]['nickname'],
        imgUrl: maps[i]['imgUrl'],
      );
    });
  }

  Future close() async {
    final Database db = await database;
    await db.close();
  }
}
