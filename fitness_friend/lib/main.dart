import 'package:fitnessfriend/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'FoodLog.dart';
import 'Register.dart';
import 'bloc/food_bloc.dart';
import 'database_helper.dart';
import 'LoginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FoodBloc>(
        create: (context) => FoodBloc(),
    child: MaterialApp(
      title: 'Fitness Friend',

      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    ),
    );
  }
}


