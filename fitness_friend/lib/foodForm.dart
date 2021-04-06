import 'package:fitnessfriend/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Events/add_food.dart';
import 'Events/update_food.dart';
import 'bloc/food_bloc.dart';
import 'model/Food.dart';

class FoodForm extends StatefulWidget {
  final Food food;
  final int foodIndex;

  FoodForm({this.food, this.foodIndex});

  @override
  State<StatefulWidget> createState() {
    return FoodFormState();
  }
}

class FoodFormState extends State<FoodForm> {
  String _name;
  String _calories;
  String _protien;
  String _carbohydrates;
  String _fats;
  String _serving;

  Future<int> getCurrentUID(String key) async {
    var pref = await SharedPreferences.getInstance();
    var number = pref.getInt(key);
    return number;
  }

  var UID;

  @override
  void initState() {
    super.initState();
    getCurrentUID('UID').then((value) =>
    UID = value
    );
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 15,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildCalories() {
    return TextFormField(
      initialValue: _calories,
      decoration: InputDecoration(labelText: 'Calories'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        int calories = int.tryParse(value);

        if (calories == null || calories <= 0) {
          return 'Calories must be greater than 0';
        }

        return null;
      },
      onSaved: (String value) {
        _calories = value;
      },
    );
  }

  Widget _buildProtien() {
    return TextFormField(
      initialValue: _protien,
      decoration: InputDecoration(labelText: 'Protien'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),

      onSaved: (String value) {
        _protien = value;
      },
    );
  }

  Widget _buildCarbohydrates() {
    return TextFormField(
      initialValue: _carbohydrates,
      decoration: InputDecoration(labelText: 'Carbohydrates'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),

      onSaved: (String value) {
        _carbohydrates = value;
      },
    );
  }

  Widget _buildFats() {
    return TextFormField(
      initialValue: _fats,
      decoration: InputDecoration(labelText: 'Fats'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),

      onSaved: (String value) {
        _fats = value;
      },
    );
  }

  Widget _buildServing() {
    return TextFormField(
      initialValue: _serving,
      decoration: InputDecoration(labelText: 'Serving Size'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),

      onSaved: (String value) {
        _serving = value;
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Form")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              _buildCalories(),
              _buildProtien(),
              _buildCarbohydrates(),
              _buildFats(),
              _buildServing(),
              SizedBox(height: 20),
              widget.food == null
                  ? RaisedButton(
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }

                  _formKey.currentState.save();

                  Food food = Food(
                    name: _name,
                    calories: _calories,
                    protiens: _protien,
                    carbohydrates: _carbohydrates,
                    fats: _fats,
                    servingSize: _serving,
                    userFK: UID,
                  );

                  DatabaseHelper.instance.foodInsert(food).then(
                        (storedFood) =>
                        BlocProvider.of<FoodBloc>(context).add(
                          AddFood(storedFood),
                        ),
                  );

                  Navigator.pop(context);
                },
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        print("form");
                        return;
                      }

                      _formKey.currentState.save();

                      Food food = Food(
                          name: _name,
                          calories: _calories,
                          protiens: _protien,
                          carbohydrates: _carbohydrates,
                          fats: _fats,
                          servingSize: _serving,
                          userFK: UID,
                      );

                      DatabaseHelper.instance.foodUpdate(widget.food).then(
                            (storedFood) =>
                            BlocProvider.of<FoodBloc>(context).add(
                              UpdateFood(widget.foodIndex, food),
                            ),
                      );

                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

