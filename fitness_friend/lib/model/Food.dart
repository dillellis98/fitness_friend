import 'package:fitnessfriend/database_helper.dart';

class Food {
  int fid;
  String name;
  var calories;
  var protiens;
  var carbohydrates;
  var fats;
  var servingSize;
  int userFK;

  Food({
    this.fid,
    this.name,
    this.calories,
    this.protiens,
    this.carbohydrates,
    this.fats,
    this.servingSize,
    this.userFK,
  });


Map<String, dynamic> toMap() {

  var map = <String, dynamic>{
    DatabaseHelper.foodName: name,
    DatabaseHelper.foodCalories: calories,
    DatabaseHelper.foodProtiens: protiens,
    DatabaseHelper.foodCarbohydrates: carbohydrates,
    DatabaseHelper.foodFats: fats,
    DatabaseHelper.foodServing: servingSize,
    DatabaseHelper.userFK: userFK,
  };

  if (fid != null) {
    map[DatabaseHelper.foodID] = fid;
  }

  return map;
}

Food.fromMap(Map<String, dynamic> map) {
fid = map[DatabaseHelper.foodID];
name = map[DatabaseHelper.foodName];
calories = map[DatabaseHelper.foodCalories];
protiens = map[DatabaseHelper.foodProtiens];
carbohydrates = map[DatabaseHelper.foodCarbohydrates];
fats = map[DatabaseHelper.foodFats];
servingSize = map[DatabaseHelper.foodServing];
userFK = map[DatabaseHelper.userFK];

}
}

