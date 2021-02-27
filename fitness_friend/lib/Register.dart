import 'dart:math';

import 'package:fitnessfriend/LoginPage.dart';
import 'package:fitnessfriend/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FoodLog.dart';
import 'database_helper.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  static var weight = 0.0;
  static int height = 0;
  static var goals = 0.0;
  static double _dailyActivity;
  static var username;
  static var password;
  static var birthday;
  static var age;
  static String _gender;
  static var dailyCals;
  static var dailyProtien;
  static var dailyCarbs;
  static var dailyFat;
  bool _validate = false;

    final usernameCon = new TextEditingController();
    final passwordCon = new TextEditingController();



  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Please enter your details',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: 60.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(fontSize: 20),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff68D065)),
                    ),
                    errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  ),
                  controller: usernameCon,
                ),
                SizedBox(height: 20.0),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(fontSize: 20),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff68D065)),
                    ),
                    errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  ),
                  controller: passwordCon,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'date of birth',
                  //textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 50,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime(1969, 1, 1),
                    onDateTimeChanged: (DateTime newDateTime) {
                      birthday = newDateTime;
                      age = calculateAge(birthday);
                      // Do something
                    },
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Weight:   ',
                      ),
                      Text(
                        weight.round().toString(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'kg',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ]),
                Slider(
                  label: weight.toString(),
                  value: weight.toDouble(),
                  min: 0.0,
                  max: 150.0,
                  onChanged: (val) {
                    print(val);
                    setState(() {
                      weight = val;
                    });
                    weight = double.parse(val.toStringAsFixed(2));
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Height:   ',
                      ),
                      Text(
                        height.round().toString(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'cm',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ]),
                Slider(
                  label: height.round().toString(),
                  value: height.toDouble(),
                  min: 0.0,
                  max: 250.0,
                  onChanged: (val) {
                    print(val);
                    setState(() {
                      height = val.round();
                    });
                  },
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Goal   :',
                      ),
                      Text(
                        goals.round().toString(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'kg',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ]),
                Slider(
                  label: goals.round().toString(),
                  value: goals,
                  min: -5.0,
                  max: 5.0,
                  divisions: 10,
                  onChanged: (val) {
                    print(val);
                    setState(() {
                      goals = val;
                    });
                  },
                ),
                SizedBox(
                  height: 60,
                child: new DropdownButton<double>(
                  hint: _dailyActivity == null
                      ? Text('Daily activity?')
                      : Text(
                    _dailyActivity.toString(),
                    style: TextStyle(fontSize: 20,),
                  ),
                  isExpanded: true,
                  items:[
                      DropdownMenuItem(
                        child: Text("little or no exercise, desk job"),
                        value: 1.2,
                      ),
                      DropdownMenuItem(
                        child: Text("light exercise/ sports 1-3 days/week"),
                        value: 1.375,
                      ),
                      DropdownMenuItem(
                          child: Text("moderate exercise/ sports 6-7 days/week"),
                          value: 1.55
                      ),
                      DropdownMenuItem(
                          child: Text("(hard exercise every day, or exercising 2 xs/day"),
                          value: 1.725
                      ),
                    DropdownMenuItem(
                        child: Text("hard exercise 2 or more times per day, or elite training"),
                        value: 1.9
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _dailyActivity = value;
                    });
                  },
                ),
                ),
                SizedBox(
                  height: 60,
                  child: new DropdownButton<String>(
                    hint: _gender == null
                        ? Text('Gender?')
                        : Text(
                      _gender,
                      style: TextStyle(fontSize: 20,),
                    ),
                    isExpanded: true,
                    items: <String>[
                      'Male',
                      'Female'
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    ButtonTheme(
                      height: 50,
                      disabledColor: Color(0xff68D065),
                      child: RaisedButton(
                        disabledElevation: 4.0,
                        onPressed: () async {
                          setState(() {
                            usernameCon.text.isEmpty ? _validate = true : _validate = false;
                            passwordCon.text.isEmpty ? _validate = true : _validate = false;

                            if (_gender == "Male") {
                              dailyCals =
                                  ((10 * weight) + (6.25 * height) - (5 * age) +
                                      5) * _dailyActivity;
                              print("cals is $dailyCals");
                              print("weight is $weight");
                              print("height is $height");
                              print("age is $age");
                              print("gender is $_gender");
                            }

                            if (_gender == "Female") {
                              dailyCals =
                                  10 * weight + 6.25 * height - 5 * age -
                                      161 * _dailyActivity;
                              print("cals is $dailyCals");
                              print("weight is $weight");
                              print("weight is $height");
                              print("age is $age");
                              print("gender is $_gender");
                            }

                            if (goals > 0) {
                              dailyCals = dailyCals + dailyCals * 0.15;
                              print("cals is $dailyCals");
                            }
                            if (goals < 0) {
                              dailyCals = dailyCals - (dailyCals * 0.15);
                              print("cals is $dailyCals");
                            }

                            dailyCals = dailyCals.round();

                            //2.2 grams per kilo
                            dailyProtien = weight * 2.2;
                            dailyProtien = dailyProtien.round();
                            print("Protien : $dailyProtien");

                            // 30% of total cals
                            dailyFat = weight * 0.88;
                            dailyFat= dailyFat.round();
                            print("Fat : $dailyFat");

                            dailyCarbs = (dailyCals - ((dailyFat * 9)+(dailyProtien * 4)))/4;
                            dailyCarbs = dailyCarbs.round();
                            print("Carbs : $dailyCarbs");

                          });

                          if (_validate == false) {
                            List<Map<String,
                                dynamic>> queryRows = await DatabaseHelper
                                .instance.userQueryAll();
                            print(queryRows);
                            int i = await DatabaseHelper.instance.userInsert({
                              DatabaseHelper.userName: usernameCon.text,
                              DatabaseHelper.userPassword: passwordCon.text,
                              DatabaseHelper.userdob: '$birthday',
                              DatabaseHelper.userWeight: '$weight',
                              DatabaseHelper.userHeight: '$height',
                              DatabaseHelper.userGoal: '$goals',
                              DatabaseHelper.userActivity: '$_dailyActivity',
                              DatabaseHelper.userGender: '$_gender',
                              DatabaseHelper.dailyKcal: '$dailyCals',
                              DatabaseHelper.dailyProtien: '$dailyProtien',
                              DatabaseHelper.dailyCarbs: '$dailyCarbs',
                              DatabaseHelper.dailyFat: '$dailyFat'
                            });
                            print('the inserted id is $i');
                            _validate = true;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                          };

                        },

                        child: Text('Register',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

}

