// database_helper.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  sqfliteFfiInit() {
    throw UnimplementedError();
  }
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

/*Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'game.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }*/

Future<Database> initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'game.db');
    return  await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

   // return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE game_state (
        id INTEGER PRIMARY KEY,
        top INTEGER,
        bottom INTEGER
      )
    ''');
  }

  Future<int> saveGameState(int top, int bottom) async {
    final db = await database;
    final Map<String, dynamic> row = {
      'top': top,
      'bottom': bottom,
    };
    return await db!.insert('game_state', row);
  }

    Future <Map<String, dynamic>> getGameStateinit() async {
    final db = await database;
    final List<Map<String, dynamic>> rows = await db!.query('game_state');
    if (rows.isEmpty) {
      return {
        'top': 1,
        'bottom': 1,
      };
    }
    if (kDebugMode) {
      print('game_state'"$rows");
    }
    return rows.first;
  }

  Future <List<Map<String, dynamic>>> getGameState() async {
    final db = await database;
    final List<Map<String, dynamic>> rows = await db!.query('game_state');
    /*if (rows.isEmpty) {
      return {
        'top': 1,
        'bottom': 1,
      };
    }*/
    if (kDebugMode) {
      print('game_state'"$rows");
    }
    return rows;
  }

  Future<void> clearGameState() async {
    final db = await database;
    await db!.delete('game_state');
  }
}

