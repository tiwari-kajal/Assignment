import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../model/trending_products.dart';

class DatabaseHelper {

  final _databaseName = "Product.db";
  final _databaseVersion = 1;
  final table = 'my_table';
  final columnId = '_id';
  final columnProductId = 'id';
  final columnTitle = 'title';
  final columnDescription = 'description';
  final columnPrice = 'price';
  final columnBrand = 'brand';
  final columnRating = 'rating';
  final columnCategory = 'category';
  final columnThumbnail = 'thumbnail';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE product (
            $columnId INTEGER PRIMARY KEY,
            $columnProductId INTEGER NOT NULL,
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnPrice INTEGER NOT NULL,
            $columnBrand TEXT NOT NULL,
            $columnRating INTEGER NOT NULL,
            $columnCategory TEXT NOT NULL,
            $columnThumbnail TEXT NOT NULL
          )
          ''');
  }

  Future insertProduct(Products products) async {
    Database? db = await instance.database;
    return await db!.insert('product', products.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Products>> getProductList() async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps =  await db!.query('product');
    return List.generate(maps.length, (index) {
      return Products(
        id : maps[index]['id'],
        title : maps[index]['title'],
        description : maps[index]['description'],
        price : maps[index]['price'],
        rating : maps[index]['rating'],
        brand : maps[index]['brand'],
        category: maps[index]['category'],
        thumbnail : maps[index]['thumbnail'],
      );
    });
  }

  Future<int> updateModel(Products products) async {
    Database? db = await instance.database;
    return await db!.update('product', products.toJson(),
        where: "id = ?", whereArgs: [products.id]);
  }

  Future<void> deleteModel(Products products) async {
    Database? db = await instance.database;
    await db!.delete('product', where: "id = ?", whereArgs: [products.id]);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query('product');
  }

  Future<int?> queryRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteAllProducts() async {
    final db = await database;
    final res = await db!.rawDelete('DELETE FROM product');
    return res;
  }
}