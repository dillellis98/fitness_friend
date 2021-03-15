import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../database_helper.dart';

class Routine{
   String routineName, imagePath, description;
   int routineID, isDefault, userFK;

  Routine({
    this.routineID,
    this.routineName,
    this.description,
    this.imagePath,
    this.isDefault,
    this.userFK
  });


Map<String, dynamic> toMap() {
  var map = <String, dynamic>{
    DatabaseHelper.routineName: routineName,
    DatabaseHelper.description: description,
    DatabaseHelper.imagePath: imagePath,
    DatabaseHelper.userFK: userFK,
    DatabaseHelper.isDefault: isDefault,
  };


  if (routineID != null) {
    map[DatabaseHelper.routineID] = routineID;
  }

  return map;
}

Routine.fromMap(Map<String, dynamic> map) {
routineID = map[DatabaseHelper.routineID];
routineName = map[DatabaseHelper.routineName];
description = map[DatabaseHelper.description];
imagePath = map[DatabaseHelper.imagePath];
isDefault = map[DatabaseHelper.isDefault];
userFK = map[DatabaseHelper.userFK];


}
}