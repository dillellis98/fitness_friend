import 'package:fitnessfriend/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Events/add_food.dart';
import 'Events/update_food.dart';
import 'bloc/food_bloc.dart';
import 'model/Food.dart';

class editFoodForm extends StatefulWidget {
  final Food foodToEdit;

  editFoodForm({this.foodToEdit});

  @override
  State<StatefulWidget> createState() {
    return editFoodFormState();
  }
}

class editFoodFormState extends State<editFoodForm> {


  Future<int> getCurrentUID(String key) async {
    var pref = await SharedPreferences.getInstance();
    var number = pref.getInt(key);
    return number;
  }

  var UID;
  var _name;
  var _calories;
  var _protien;
  var _carbohydrates;
  var _fats;
  var _serving;

  @override
  void initState() {
    super.initState();
    getCurrentUID('UID').then((value) =>
    UID = value
    );
    _name = widget.foodToEdit.name;
    _calories = widget.foodToEdit.calories;
    _protien = widget.foodToEdit.protiens;
    _carbohydrates = widget.foodToEdit.carbohydrates;
    _fats = widget.foodToEdit.fats;
    _serving = widget.foodToEdit.servingSize;
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _name.toString(),
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
      initialValue: _calories.toString(),
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
      initialValue: _protien.toString(),
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
      initialValue: _carbohydrates.toString(),
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
      initialValue: _fats.toString(),
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
      initialValue: _serving.toString(),
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

               RaisedButton(
                child: Text(
                  'Submit',
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
            ],
          ),
        ),
      ),
    );
  }
}