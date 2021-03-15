import 'dart:math';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../database_helper.dart';

class ExerciseLog{
  int logID, weight, reps, routineFK, exerciseFK;
  var logdate, trackingNum;

  ExerciseLog({
    this.logID,
    this.weight,
    this.reps,
    this.trackingNum,
    this.logdate,
    this.routineFK,
    this.exerciseFK
  });


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseHelper.logWeight: weight,
      DatabaseHelper.logReps: reps,
      DatabaseHelper.logDate: logdate,
      DatabaseHelper.trackingNum: trackingNum,
      DatabaseHelper.routineFK: routineFK,
      DatabaseHelper.exerciseFK: exerciseFK,
    };


    if (logID != null) {
      map[DatabaseHelper.logID] = logID;
    }

    return map;
  }

  ExerciseLog.fromMap(Map<String, dynamic> map) {
    logID = map[DatabaseHelper.logID];
    weight = map[DatabaseHelper.logWeight];
    reps = map[DatabaseHelper.logReps];
    trackingNum = map[DatabaseHelper.trackingNum];
    logdate = map[DatabaseHelper.logDate];
    routineFK = map[DatabaseHelper.routineFK];
    exerciseFK = map[DatabaseHelper.exerciseFK];


  }
}