import 'package:fitnessfriend/database_helper.dart';
import 'package:fitnessfriend/model/exerciseLog.dart';
import 'package:fitnessfriend/model/exerciseLog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import 'ExercisePicker.dart';
import 'model/Routine.dart';
import 'model/exercise.dart';

class TrackWorkout extends StatefulWidget {
  final int routineID;
  final List<Exercise> chosenExercises;

  const TrackWorkout(this.routineID, this.chosenExercises);

  @override
  _TrackWorkoutState createState() => _TrackWorkoutState();
}

final GlobalKey<FormState> _workoutFormKey = GlobalKey<FormState>();

class _TrackWorkoutState extends State<TrackWorkout> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    List<Widget> _exercises = new List.generate(
        widget.chosenExercises.length,
        (int i) =>
            new _logExercise((widget.chosenExercises[i]), widget.routineID, i));
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _workoutFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: _exercises,
                  shrinkWrap: true,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    minimumSize: Size.fromHeight(40),
                    primary: Color(0xff284FC2),
                  ),
                  child: Text(
                    "Finish Work Out !",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () async {
                    print("${exerciseLog.first.reps}");
                    print("${exerciseLog.first.weight}");
                    print("${exerciseLog.first.routineFK}");
                    print("${exerciseLog.first.exerciseFK}");
                    print("${exerciseLog.first.logdate}");

                    exerciseLog.forEach((element) {
                      DatabaseHelper.instance.logInsert(element);
                    });

                    exerciseLog.clear();

                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _logExercise extends StatefulWidget {
  @override
  final Exercise exercise;
  final int RID;
  final int i;

  const _logExercise(this.exercise, this.RID, this.i);

  _logExerciseState createState() => _logExerciseState();
}

class _logExerciseState extends State<_logExercise> {
  int set;
  String weight;
  String reps;
  int _count = 3;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    List<Widget> _logs = new List.generate(_count,
        (int j) => new LogRow(j, widget.i, widget.RID, widget.exercise));

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              widget.exercise.exerciseName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Set",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "KG",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Reps",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "                ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: _logs,
              shrinkWrap: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: width * 0.3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      minimumSize: Size.fromHeight(40),
                      primary: Color(0xff68D065),
                    ),
                    child: Text("Add Set"),
                    onPressed: _addNewLogRow,
                  ),
                ),
                if (_count > 3)
                  SizedBox(
                    width: width * 0.3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        minimumSize: Size.fromHeight(40),
                        primary: Colors.red,
                      ),
                      child: Text("Remove Set"),
                      onPressed: _removeLogRow,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addNewLogRow() {
    setState(() {
      _count = _count + 1;
    });
  }

  void _removeLogRow() {
    if (_count > 3)
      setState(() {
        _count = _count - 1;
      });
    else
      print("cannot go below 3");
  }
}

class LogRow extends StatefulWidget {
  final int j;
  final int i;
  final int RID;
  final Exercise exercise;

  const LogRow(this.j, this.i, this.RID, this.exercise);

  @override
  _LogRowState createState() => _LogRowState();
}

List<ExerciseLog> exerciseLog = [];

class _LogRowState extends State<LogRow> {
  List<Tuple2<int, int>> checkLog = [];
  var reps;
  var weight;

  final GlobalKey<FormState> _logformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String logTime = formatter.format(today);

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Form(
        key: _logformKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "${widget.j + 1}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 50,
              height: 25,
              child: TextFormField(
                decoration: new InputDecoration(
                  fillColor: Colors.white,
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                      color: Color(0xff68D065),
                    ),
                  ),
                ),
                onSaved: (String value) {
                  weight = value;
                },
              ),
            ),
            SizedBox(
              width: 50,
              height: 25,
              child: TextFormField(
                decoration: new InputDecoration(
                  fillColor: Colors.white,
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                      color: Color(0xff68D065),
                    ),
                  ),
                ),
                  onSaved: (String value) {
                    reps = value;
                  },
              ),
            ),
            Checkbox(
              value: checkLog.contains(Tuple2(widget.i, widget.j)),
              onChanged: (bool value) {
                print(value);
                setState(() {
                  if (value) {
                    checkLog.add(Tuple2(widget.i, widget.j));

                    _logformKey.currentState.save();

                    int weightNum = int.parse(weight);
                    int repsNum = int.parse(reps);
                    var trackNum = "${widget.i}${widget.j}";
                    print("tracking: $trackNum");

                    exerciseLog.add(ExerciseLog(
                        weight: weightNum,
                        reps: repsNum,
                        logdate: logTime,
                        trackingNum: trackNum,
                        routineFK: widget.RID,
                        exerciseFK: widget.exercise.exerciseID));


                  } else {
                    checkLog.remove(Tuple2(widget.i, widget.j));
                    var trackNum = "${widget.i}${widget.j}";
                    exerciseLog.removeWhere((element) => element.trackingNum == trackNum);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
