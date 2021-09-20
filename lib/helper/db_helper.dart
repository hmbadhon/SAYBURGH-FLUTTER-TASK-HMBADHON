import 'dart:developer';
import 'dart:io';

import 'package:movie_app/model/rpmovie_fav_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbName = 'myDatabase.db';
  static const _tableName = 'favorite';
  static const _dbVersion = 1;
  static const columnId = 'id';
  static const columnName = 'original_title';
  static const columnImage = 'poster_path';
  static const columnVote = 'vote_average';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initiateDatabase();
    return _database!;
  }

  Future<Database> _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    var database = await openDatabase(path, version: _dbVersion,
        onCreate: (Database db, int version) async {
      await db.execute('''
            CREATE TABLE $_tableName(
            $columnId INTEGER,
            $columnName TEXT,
            $columnImage TEXT,
            $columnVote DOUBLE
            )
            
        ''');
    });
    return database;
  }

  Future<List<RpMovieFavModel>> queryAllFav() async {
    List<RpMovieFavModel> _products = [];
    Database db = await instance.database;
    var results = await db.query(_tableName);
    results.forEach(
      (element) {
        var products = RpMovieFavModel.fromJson(element);
        _products.add(products);
      },
    );
    return _products;
  }

  //Insert row
  Future insertFav(RpMovieFavModel rpMovieFavModel) async {
    Database db = await instance.database;
    var result = await db.insert(
      _tableName,
      rpMovieFavModel.toJson(),
    );
    log('result : $result');
  }

  Future<int> deleteFav(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}
