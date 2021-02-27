import 'dart:math';

import 'package:fitnessfriend/LoginPage.dart';
import 'package:fitnessfriend/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FoodLog.dart';
import 'database_helper.dart';

class LogoPage extends StatelessWidget {


  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Image.asset('assets/logo.png',
        width: 250,
        height: 250,),
    );
  }

}
