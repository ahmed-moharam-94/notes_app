import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;

const String tableName = 'Notes';
const String dbName = 'notes.db';

class DBHelper {
  // create table
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE $tableName(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)
    """);
    // todo note: the id start from 1 not 0
  }

  // create db
  static Future<sql.Database> db() async {
    return await sql.openDatabase(
        // check if the db is exist or not, if not it will create one, or it will open the db
        dbName,
        version: 1, onCreate: (sql.Database database, int version) async {
      // check if the table exist or not, if not create the table
      createTable(database);
    });
  }

  // insert item
  static Future<int> createItem(String title, String? description) async {
    final db = await DBHelper.db();
    // insert the data in the Map<> format
    final data = {'title': title, 'description': description};
    final id = await db.insert(tableName, data,
        // define a conflict algorithm when there is a duplicate
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

// get items
  static Future<List<Map<String, dynamic>>> getItems() async {
    // retrieve the data as a List of Maps
    // perform a query
    final db = await DBHelper.db();
    return db.query(tableName, orderBy: 'id');
  }

// get single item
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    // retrieve one item as List of maps
    // perform a query
    final db = await DBHelper.db();
    return db.query(tableName, where: 'id = ?', whereArgs: [id], limit: 1);
  }

  // update item
  static Future<int> updateItem(
      int id, String title, String? description) async {
    final db = await DBHelper.db();

    // get the data from the user
    final data = {
      'title': title,
      'description': description,
      // don't forget to update the createAt which we made it generate automatically
      'createdAt': DateTime.now().toString(),
    };

    // now update item at specific id
    final result = db.update(tableName, data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  // delete item
  static Future<void> deleteItem(int id) async {
    final db = await DBHelper.db();
    try {
      await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    } catch (error) {
      debugPrint('something went wrong when delete an item');
    }
  }
}


//todo note: If you added a new table or did some modifications to the database, you have to reinstall the application.
