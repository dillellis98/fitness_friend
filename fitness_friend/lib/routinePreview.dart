import 'package:fitnessfriend/model/exercise.dart';
import 'package:fitnessfriend/trackWorkout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'database_helper.dart';

class RoutinePreview extends StatefulWidget {
  final int routineID;
  final String routineName;

  RoutinePreview(this.routineID, this.routineName);

  @override
  _RoutinePreviewState createState() => _RoutinePreviewState();
}

class _RoutinePreviewState extends State<RoutinePreview> {
  List<Exercise> previewExercises;

  var isLoading = true;

  getExerciseList() async {
    previewExercises =
        await DatabaseHelper.instance.getRoutineExercises(widget.routineID);
  }

  asyncMethod() async {
    await getExerciseList();
  }

  @override
  void initState() {
    super.initState();
    asyncMethod().then((result) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final today = DateTime.now();

    if (isLoading == true) {
      return Scaffold(
        backgroundColor: Color(0xFFE9E9E9),
        body: Center(
          child: Image.asset(
            'assets/logo.png',
            width: height * 0.3,
            height: height * 0.3,
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Color(0xFFE9E9E9),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: height * 0.05),
              IconButton(
                icon: Icon(FontAwesomeIcons.timesCircle,
                    color: Color(0xff68D065), size: height * 0.05),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: height * 0.05),
              Text(widget.routineName,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: height * 0.05),
              SizedBox( height: height * 0.5,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: previewExercises.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      title: Text(
                        previewExercises[index].exerciseName,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      minimumSize: Size.fromHeight(40),
                      primary: Color(0xff68D065),
                    ),
                    child: Text(
                      "Do Workout !",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              TrackWorkout(widget.routineID, previewExercises)));
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
