import 'dart:async';

import 'package:fitnessfriend/database_helper.dart';
import 'package:fitnessfriend/model/exercise.dart';
import 'package:fitnessfriend/widget/ExerciseListTile.dart';
import 'package:fitnessfriend/widget/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/RoutineExercise.dart';
import 'model/Routine.dart';

class ExercisePicker extends StatefulWidget {
  final String routineName;
  final String routineDesc;
  final bool multiSelect;
  final List<Exercise> allExercises;

  ExercisePicker(
      this.routineName, this.routineDesc, this.multiSelect, this.allExercises);

  @override
  _ExercisePickerState createState() => _ExercisePickerState();
}

class _ExercisePickerState extends State<ExercisePicker> {
  Future<int> getCurrentUID(String key) async {
    var pref = await SharedPreferences.getInstance();
    var number = pref.getInt(key);
    return number;
  }

  var UID;

  //List<Exercise> allExercises;
  List<Exercise> selectedExercises = [];
  bool isLoading = true;
  String searchtext = '';


  @override
  void initState() {
    super.initState();
    getCurrentUID('UID').then((value) => UID = value);

  }



  bool containsSearchText(Exercise exercise) {
    final name = exercise.exerciseName;
    final textLower = searchtext.toLowerCase();
    final countryLower = name.toLowerCase();

    return countryLower.contains(textLower);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final today = DateTime.now();

    var exerciseList = widget.allExercises.where(containsSearchText).toList();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff68D065),
          title: Text('Select Exercises'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: SearchWidget(
              text: searchtext,
              onChanged: (searchtext) =>
                  setState(() => this.searchtext = searchtext),
              hintText: 'Search Exercise',
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: exerciseList.map((exercise) {
                  final isSelected = selectedExercises.contains(exercise);

                  return ExerciseListTile(
                    exercise: exercise,
                    isSelected: isSelected,
                    onSelectedExercise: selectExercise,
                  );
                }).toList(),
              ),
            ),
            Visibility(
              visible: (widget.multiSelect == true),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    minimumSize: Size.fromHeight(40),
                    primary: Color(0xff68D065),
                  ),
                  child: Text(
                    "Select ${selectedExercises.length} Exercises",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    if (selectedExercises.length > 1) {
                      Routine routine = Routine(
                        routineName: widget.routineName,
                        description: widget.routineDesc,
                        imagePath: "assets/gymthings.png",
                        isDefault: 0,
                        userFK: UID,
                      );
                      DatabaseHelper.instance
                          .routineInsert(routine)
                          .then((value) =>
                          selectedExercises.forEach((element) {
                            RoutineExercise routineExercise = RoutineExercise(
                                routineFK: value,
                                exerciseFK: element.exerciseID);

                            DatabaseHelper.instance
                                .linkTableInsert(routineExercise);
                          }));

                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);
                    }
                    else
                      moreExercise(context);
                  },
                ),
              ),
            ),
          ],
        ));
  }

  void selectExercise(Exercise exercise) async {
    if (widget.multiSelect == true) {
      final isSelected = selectedExercises.contains(exercise);
      setState(() => isSelected
          ? selectedExercises.remove(exercise)
          : selectedExercises.add(exercise));
    } else {

      var result = await DatabaseHelper.instance.setgraphed(exercise.exerciseID);
      Navigator.pop(context, exercise);
    }
  }

  void moreExercise(BuildContext context){

    var alertDialog = AlertDialog(
      title: Text("Not enough Exercises"),
      content: Text("please select at least 1 exercise"),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) => alertDialog
    );
  }
}
