import 'dart:convert';
import 'dart:io';

import 'package:fitnessfriend/model/exercise.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fitnessfriend/model/Food.dart';

import 'model/Food.dart';
import 'model/Routine.dart';
import 'model/User.dart';

class DatabaseHelper {
  static final _dbName = 'progress.db';
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
  static final calsLeft = 'calsLeft';
  static final protienLeft = 'protienLeft';
  static final carbsLeft = 'carbsLeft';
  static final fatLeft = 'fatLeft';


  static const String foodTable = "foodTable";
  static const String foodID = "foodID";
  static const String foodName = "name";
  static const String foodCalories = "calories";
  static const String foodProtiens = "protiens";
  static const String foodCarbohydrates = "carbohydrates";
  static const String foodFats = "fats";
  static const String foodServing = "servingSize";
  static const String userFK = "userFK";

  static const String exerciseTable = "exercise";
  static const String exerciseID = "exerciseID";
  static const String exerciseName = "exerciseName";
  static const String muscleGroupFK = "muscleGroupFK";

  static const String muscleTable = "muscleTable";
  static const String muscleGroupID = "muscleGroupID";
  static const String muscleGroup = "muscleGroup";

  static const String routineTable = "routineTable";
  static const String routineID = "routineID";
  static const String routineName = "routineName";
  static const String description = "description";
  static const String imagePath = "imagePath";

  static const String routine_exercise = "routine_exercise";
  static const String exerciseFK = "exerciseFK";
  static const String routineFK = "routineFK";


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

  Future _onCreate(Database db, int version) async {
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
      $dailyFat NUMBER NOT NULL,
      $calsLeft NUMBER NOT NULL,
      $protienLeft NUMBER NOT NULL,
      $carbsLeft NUMBER NOT NULL,
      $fatLeft NUMBER NOT NULL
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

    db.execute('''
        CREATE TABLE $muscleTable(
        $muscleGroupID INTEGER PRIMARY KEY,
        $muscleGroup TEXT NOT NULL
        )
        ''');

    db.execute('''
        INSERT INTO $muscleTable VALUES
        (1, "Chest"),
        (2, "Back"),
        (3, "Shoulders"),
        (4, "Arms"),
        (5, "Core"),
        (6, "Legs")
        ''');

    db.execute('''
        CREATE TABLE $exerciseTable(
        $exerciseID INTEGER PRIMARY KEY,
        $exerciseName TEXT NOT NULL,
        $muscleGroupFK INTEGER,
        FOREIGN KEY($muscleGroupFK) REFERENCES $muscleTable($muscleGroupID)
        )
        ''');

    db.execute('''
        CREATE TABLE $routineTable(
        $routineID INTEGER PRIMARY KEY,
        $routineName TEXT NOT NULL,
        $description TEXT NOT NULL,
        $imagePath TEXT
        )
        ''');


    Batch batch = db.batch();

    String exerciseJson = await rootBundle.loadString('assets/exercises.json');
    List exerciseList = json.decode(exerciseJson);


    exerciseList.forEach((val) {
      Exercise exercise = Exercise.fromMap(val);
      batch.insert(exerciseTable, exercise.toMap());
    });

    String workoutJson = await rootBundle.loadString('assets/workouts.json');
    List workoutList = json.decode(workoutJson);


    workoutList.forEach((val) {
      Routine routine = Routine.fromMap(val);
      batch.insert(routineTable, routine.toMap());
    });

    batch.commit();

    db.execute('''
    CREATE TABLE $routine_exercise(
    $routineFK INTEGER NOT NULL,
    $exerciseFK INTEGER NOT NULL,
    CONSTRAINT [RFK] FOREIGN KEY($routineFK) REFERENCES $routineTable($routineID),
    CONSTRAINT [EFK] FOREIGN KEY($exerciseFK) REFERENCES $exerciseTable($exerciseID),
    CONSTRAINT [RFK_EFK] PRIMARY KEY ($routineFK, $exerciseID)
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

  Future<User> getUser(int UID) async {
    Database db = await instance.database;

    int uid = UID;
    var user = await db.query(
      userTable,
      columns: [
        userID,
        userName,
        userPassword,
        userdob,
        userWeight,
        userGoal,
        userActivity,
        userGender,
        dailyKcal,
        dailyProtien,
        dailyCarbs,
        dailyFat,
        calsLeft,
        protienLeft,
        carbsLeft,
        fatLeft

      ],
      where: "userID = ?",
      whereArgs: [uid],
    );

    List<User> userList = List<User>();

    user.forEach((currentUser) {
      User user = User.fromMap(currentUser);

      userList.add(user);
    });

    User result = userList.first;

    return result;
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

  Future<int> getFatLeft(int uid) async {
    Database db = await instance.database;
    int res = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT $fatLeft FROM $userTable WHERE userID = '$uid'"));
    print("DB fats left are $res");

    return res;
  }

  Future<int> getCalsLeft(int uid) async {
    Database db = await instance.database;
    int res = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT $calsLeft FROM $userTable WHERE userID = '$uid'"));
    print("DB cals left are $res");

    return res;
  }

  Future<int> getProtienLeft(int uid) async {
    Database db = await instance.database;
    int res = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT $protienLeft FROM $userTable WHERE userID = '$uid'"));
    print("DB fats are $res");

    return res;
  }

  Future<int> getCarbsLeft(int uid) async {
    Database db = await instance.database;
    int res = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT $carbsLeft FROM $userTable WHERE userID = '$uid'"));
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
    var cals = food.calories;
    var protien = food.protiens;
    var carbs = food.carbohydrates;
    var fat = food.fats;
    var uid = food.userFK;
    final db = await instance.database;
    food.fid = await db.insert(foodTable, food.toMap());
    await db.rawQuery("UPDATE $userTable SET"
                      " $calsLeft = $calsLeft - $cals,"
                      " $protienLeft = $protienLeft - $protien,"
                      " $carbsLeft = $carbsLeft - $carbs,"
                      " $fatLeft = $fatLeft -$fat"
                      " WHERE $userID = $uid");
    return food;
  }

  Future<int> foodDelete(Food food) async {
    final db = await instance.database;

    var cals = food.calories;
    var protien = food.protiens;
    var carbs = food.carbohydrates;
    var fat = food.fats;
    var uid = food.userFK;

    await db.rawQuery("UPDATE $userTable SET"
        " $calsLeft = $calsLeft + $cals,"
        " $protienLeft = $protienLeft + $protien,"
        " $carbsLeft = $carbsLeft + $carbs,"
        " $fatLeft = $fatLeft + $fat"
        " WHERE $userID = $uid");

    return await db.delete(
      foodTable,
      where: "foodID = ?",
      whereArgs: [food.fid],
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

//ROUTINE TABLE QUERIES
//--------------------------------------------------------------//

  Future<List<Routine>> getRoutine() async {
    final db = await instance.database;
    var routines = await db.query(
      routineTable,
      columns: [
        routineID,
        routineName,
        description,
        imagePath
      ]
    );

    List<Routine> routineList = List<Routine>();

    routines.forEach((currentRoutine) {
      Routine routine = Routine.fromMap(currentRoutine);

      routineList.add(routine);
    });

    return routineList;
  }
}