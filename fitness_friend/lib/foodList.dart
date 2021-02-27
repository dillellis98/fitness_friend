import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Events/delete_food.dart';
import 'Events/set_foods.dart';
import 'bloc/food_bloc.dart';
import 'database_helper.dart';
import 'foodForm.dart';
import 'model/Food.dart';

class FoodList extends StatefulWidget {
  final int uid;

  const FoodList(this.uid);

  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
//  Future<int> getCurrentUID(String key) async {
//    var pref = await SharedPreferences.getInstance();
//    int number = pref.getInt(key);
//    return number;
//  }
//
//
//  int UID;

  @override
  void initState() {
    super.initState();
//    getCurrentUID('UID').then((value) =>
//    UID = value
//    );
//
//    final currentUID = UID;

    DatabaseHelper.instance.getFoods(widget.uid).then(
      (foodList) {
        BlocProvider.of<FoodBloc>(context).add(SetFoods(foodList));
      },
    );
  }

  showFoodDialog(BuildContext context, Food food, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(food.name),
        content: Text("ID ${food.fid}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FoodForm(food: food, foodIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          FlatButton(
            onPressed: () =>
                DatabaseHelper.instance.foodDelete(food.fid).then((_) {
              BlocProvider.of<FoodBloc>(context).add(
                DeleteFood(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print(widget.uid);
    return Container(
      height: height * 0.5,
      padding: EdgeInsets.all(8),
      color: Color(0xFFE9E9E9),
      child: BlocConsumer<FoodBloc, List<Food>>(
        builder: (context, foodList) {
          return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                print("foodList: $foodList");

                Food food = foodList[index];
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    title: Text(food.name, style: TextStyle(fontSize: 26)),
                    subtitle: Text(
                      "Calories: ${food.calories}",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () => showFoodDialog(context, food, index),
                  ),
                );
              },
              itemCount: foodList.length,

          );
        },
        listener: (BuildContext context, foodList) {},
      ),
    );
  }
}
