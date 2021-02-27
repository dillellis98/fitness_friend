import 'package:fitnessfriend/database_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class User {
  int userID;
  String userName;
  String userPassword;
  var userdob;
  var userWeight;
  var userHeight;
  int userGoal;
  String userActivity;
  String userGender;
  var dailyKcal;
  var dailyProtien;
  var dailyCarbs;
  var dailyFat;

  User({
    this.userID,
    this.userName,
    this.userPassword,
    this.userdob,
    this.userWeight,
    this.userHeight,
    this.userGoal,
    this.userActivity,
    this.userGender,
    this.dailyKcal,
    this.dailyProtien,
    this.dailyCarbs,
    this.dailyFat,

  });


  Map<String, dynamic> toMap() {

    var map = <String, dynamic>{
      DatabaseHelper.userName: userName,
      DatabaseHelper.userPassword: userPassword,
      DatabaseHelper.userdob: userdob,
      DatabaseHelper.userWeight: userWeight,
      DatabaseHelper.userHeight: userHeight,
      DatabaseHelper.userGoal: userGoal,
      DatabaseHelper.userActivity: userActivity,
      DatabaseHelper.userGender: userGender,
      DatabaseHelper.dailyKcal: dailyKcal,
      DatabaseHelper.dailyProtien: dailyProtien,
      DatabaseHelper.dailyCarbs: dailyCarbs,
      DatabaseHelper.dailyFat: dailyFat,
    };

    if (userID != null) {
      map[DatabaseHelper.userID] = userID;
    }

    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    userID = map[DatabaseHelper.userID];
    userName = map[DatabaseHelper.userName];
    userPassword = map[DatabaseHelper.userPassword];
    userdob = map[DatabaseHelper.userdob];
    userWeight = map[DatabaseHelper.userWeight];
    userHeight = map[DatabaseHelper.userHeight];
    userGoal = map[DatabaseHelper.userGoal];
    userActivity = map[DatabaseHelper.userActivity];
    userGender = map[DatabaseHelper.userGender];
    dailyKcal = map[DatabaseHelper.dailyKcal];
    dailyProtien = map[DatabaseHelper.dailyProtien];
    dailyCarbs = map[DatabaseHelper.dailyCarbs];
    dailyFat = map[DatabaseHelper.dailyFat];

  }
}

