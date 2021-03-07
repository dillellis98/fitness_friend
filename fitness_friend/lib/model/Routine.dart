import '../database_helper.dart';

class Routine{
   String routineName, imagePath, description;
   int routineID;

  Routine({
    this.routineID,
    this.routineName,
    this.description,
    this.imagePath
  });


Map<String, dynamic> toMap() {
  var map = <String, dynamic>{
    DatabaseHelper.routineName: routineName,
    DatabaseHelper.description: description,
    DatabaseHelper.imagePath: imagePath

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


}
}