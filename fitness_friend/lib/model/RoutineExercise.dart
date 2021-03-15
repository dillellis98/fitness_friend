import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../database_helper.dart';

class RoutineExercise{
  int routine_exercisePK, routineFK, exerciseFK;

  RoutineExercise({
    this.routine_exercisePK,
    this.routineFK,
    this.exerciseFK
  });


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseHelper.routineFK: routineFK,
      DatabaseHelper.exerciseFK: exerciseFK,
    };

    if (routine_exercisePK != null) {
      map[DatabaseHelper.routine_exercisePK] = routine_exercisePK;
    }

    return map;
  }

  RoutineExercise.fromMap(Map<String, dynamic> map) {

    routine_exercisePK = map[DatabaseHelper.routine_exercisePK];
    routineFK = map[DatabaseHelper.routineFK];
    exerciseFK = map[DatabaseHelper.exerciseFK];


  }
}