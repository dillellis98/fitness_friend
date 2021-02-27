import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fitnessfriend/model/Food.dart';

import 'model/Food.dart';

class DatabaseHelper {
  static final _dbName = 'newtest.db';
  static final _dbVersion = 1;
  static final userTable = 'user';
  static final userID = 'userID';
  static final userName = 'username';
  static final userPassword = 'password';
  static final userdob = 'birthday';
  static final userWeight = 'weight';
  static final userHeight = 'height';
  static final userGoal = 'goals';
  static final userActivity = 'activity';
  static final userGender = 'userGender';
  static final dailyKcal = 'dailyKcal';
  static final dailyProtien = 'dailyProtien';
  static final dailyCarbs = 'dailyCarbs';
  static final dailyFat = 'dailyFat';


  static const String foodTable = "foodTable";
  static const String foodID = "foodID";
  static const String foodName = "name";
  static const String foodCalories = "calories";
  static const String foodProtiens = "protiens";
  static const String foodCarbohydrates = "carbohydrates";
  static const String foodFats = "fats";
  static const String foodServing = "servingSize";
  static const String userFK = "userFK";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE $userTable( 
      $userID INTEGER PRIMARY KEY,
      $userName TEXT NOT NULL,
      $userPassword TEXT NOT NULL,
      $userdob TEXT NOT NULL,
      $userWeight NUMBER NOT NULL,
      $userHeight NUMBER NOT NULL,
      $userGoal INTEGER NOT NULL,
      $userActivity NUMBER NOT NULL,
      $userGender TEXT NOT NULL,
      $dailyKcal NUMBER NOT NULL,
      $dailyProtien NUMBER NOT NULL,
      $dailyCarbs NUMBER NOT NULL,
      $dailyFat NUMBER NOT NULL
      
       )
      ''');

    db.execute('''
        CREATE TABLE $foodTable(
        $foodID INTEGER PRIMARY KEY,
        $foodName TEXT NOT NULL,
        $foodCalories INTEGER NOT NULL,
        $foodProtiens REAL NOT NULL,
        $foodCarbohydrates REAL NOT NULL,
        $foodFats REAL NOT NULL,
        $foodServing REAL NOT NULL,
        $userFK INTEGER,
        FOREIGN KEY($userFK) REFERENCES $userTable($userID)
        )
        ''');
  }

  //USER TABLE QUERIES
  //--------------------------------------------------------------//
  Future<int> userInsert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(userTable, row);
  }

  Future<List<Map<String, dynamic>>> userQueryAll() async {
    Database db = await instance.database;
    return await db.query(userTable);
  }

  Future userUpdate(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[userName];
    return await db.update(userTable, row, where: 'userID =?', whereArgs: [id]);
  }

  Future getUserID(String userName) async {
    Database db = await instance.database;
    int uid = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT $userID FROM $userTable WHERE username = '$userName'"));
    print("user id is $uid");
    return uid;
  }

  Future<int> getUserCarbs(int uid) async {
    Database db = await instance.database;
    int res = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT $dailyCarbs FROM $userTable WHERE userID = '$uid'"));
    print("DB carbs are $res");

    return res;
  }

  Future<int> getUserCals(int uid) async {
    Database db = await instance.database;
    int res = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT $dailyKcal FROM $userTable WHERE userID = '$uid'"));
    print("DB cals are $res");

    return res;
  }

  Future<int> getUserProtein(int uid) async {
    Database db = await instance.database;
    int res = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT $dailyProtien FROM $userTable WHERE userID = '$uid'"));
    print("DB protien are $res");

    return res;
  }

  Future<int> getUserFat(int uid) async {
    Database db = await instance.database;
    int res = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT $dailyFat FROM $userTable WHERE userID = '$uid'"));
    print("DB fats are $res");

    return res;
  }

  Future<int> checkLogin(String userName, String password) async {
    final dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT * FROM $userTable WHERE username = '$userName' and password = '$password'");

    print("$res");

    if (res.length > 0) {
      return 1;
    }

    return null;
  }

  //FOOD TABLE QUERIES
  //--------------------------------------------------------------//
  Future<List<Food>> getFoods(int UID) async {
    final db = await instance.database;
    int uid = UID;
    var foods = await db.query(
      foodTable,
      columns: [
        foodID,
        foodName,
        foodCalories,
        foodProtiens,
        foodCarbohydrates,
        foodFats,
        foodServing,
        userFK
      ],
      where: "userFK = ?",
      whereArgs: [uid],
    );

    List<Food> foodList = List<Food>();

    foods.forEach((currentFood) {
      Food food = Food.fromMap(currentFood);

      foodList.add(food);
    });

    return foodList;
  }

  Future<Food> foodInsert(Food food) async {
    final db = await instance.database;
    food.fid = await db.insert(foodTable, food.toMap());
    return food;
  }

  Future<int> foodDelete(int id) async {
    final db = await instance.database;

    return await db.delete(
      foodTable,
      where: "foodID = ?",
      whereArgs: [id],
    );
  }

  Future<int> foodUpdate(Food food) async {
    final db = await instance.database;

    return await db.update(
      foodTable,
      food.toMap(),
      where: "foodID = ?",
      whereArgs: [food.fid],
    );
  }
}
