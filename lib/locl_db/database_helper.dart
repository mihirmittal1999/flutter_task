// ignore_for_file: depend_on_referenced_packages

import 'dart:io' as io;

import 'package:flutter_task/locl_db/database_constants.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? _database;
  static const _databaseName = "demo.db";
  static const _databaseVersion = 1;
  DatabaseHelper._();
  static final DatabaseHelper dbInstance = DatabaseHelper._();

  Future<Database> get database async => _database ??= await _createDatabase();

  _createDatabase() async {
    io.Directory dataDirectory = await getApplicationDocumentsDirectory();
    return await openDatabase(
      path.join(dataDirectory.path, _databaseName),
      version: _databaseVersion,
      onCreate: _onCreateDB,
    );
  }

  //------------------ TABLE ------------------

  Future _onCreateDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE ${DatabaseConstants.tblName} (${'ApiData'} TEXT NOT NULL)
    ''');
  }

  Future<int> insertApiData(object) async {
    Database db = await database;
    return db.insert(DatabaseConstants.tblName, object);
  }

  Future<List<Map<String, Object?>>> getApiData() async {
    Database db = await database;
    return await db.query(DatabaseConstants.tblName);
  }

  //----------------------DB Close----------------------

  Future<void> closeDB() async {
    if (_database != null) return await _database?.close();
    _database = null;
  }
}
