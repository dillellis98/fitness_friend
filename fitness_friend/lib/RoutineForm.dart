import 'package:fitnessfriend/database_helper.dart';
import 'package:fitnessfriend/fieldValidator.dart';
import 'package:flutter/material.dart';

import 'ExercisePicker.dart';
import 'model/Routine.dart';
import 'model/exercise.dart';

class RoutineForm extends StatefulWidget {
  final int uid;


  RoutineForm(this.uid);
  @override
  _RoutineFormState createState() => _RoutineFormState();
}

final GlobalKey<FormState> _routineFormKey = GlobalKey<FormState>();

class _RoutineFormState extends State<RoutineForm> {
  var _routineName;
  var _routineDesc;
  List<Exercise> allExercises;

  getExerciseList() async {
    allExercises = await DatabaseHelper.instance.getExercises();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body:  SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _routineFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
             Text("Create your new Routine",
                  style: TextStyle(fontSize: 28,
                  color: Color(0xff68D065),
                  fontWeight: FontWeight.bold),
             ),
              Image.asset(
              'assets/routineList.PNG',
              width: height * 0.3,
              height: height * 0.3,
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: _routineName,
                decoration: new InputDecoration(
                  labelText: "Routine name",
                  fillColor: Colors.white,
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(color: Color(0xff68D065),
                    ),
                  ),
                ),
                onSaved: (String value) {
                  _routineName = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: _routineDesc,
                decoration: new InputDecoration(
                  labelText: "Routine Description",
                  fillColor: Colors.white,
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(color: Color(0xff68D065),
                    ),
                  ),
                ),
                onSaved: (String value) {
                  _routineDesc = value;
                },
              ),
              SizedBox(height: 20),
          ButtonTheme(
            height: 50,
            disabledColor: Color(0xff68D065),
              child: RaisedButton(
                child: Text('Confirm',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: () async{
                  _routineFormKey.currentState.save();
                  print("$_routineName : $_routineDesc");

                  await getExerciseList();

                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        ExercisePicker(_routineName, _routineDesc,true ,allExercises)));},
              ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}
