import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fitnessfriend/model/Routine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final today = DateTime.now();

    return new Scaffold(
      backgroundColor: Color(0xFFE9E9E9),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            height: height * 0.35,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(40),
              ),
              child: Container(
                color: Colors.white,
                padding:
                    EdgeInsets.only(top: 30, left: 32, right: 16, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        "Work Out",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.15,
                      child: RaisedButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: Color(0xFFE9E9E9),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.plusCircle,
                              color: Color(0xff68D065),
                              size: 50,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Create A Routine",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Customise your own routine from a selection of exercises.",
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.37,
            left: 0,
            right: 0,
            child: Container(
              height: height * 0.28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                      left: 32,
                      right: 16,
                    ),
                    child: Text("Work out Routines",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        )),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          for (int i = 0; i < routines.length; i++)
                            _routineCard(
                              routine: routines[i],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: height * 0.65,
            left: 0,
            right: 0,
            child: Container(
              height: height * 0.28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                      left: 32,
                      right: 16,
                    ),
                    child: Text("My Work out Routines",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        )),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          for (int i = 0; i < routines.length; i++)
                            _routineCard(
                              routine: routines[i],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _routineCard extends StatelessWidget {
  final Routine routine;

  const _routineCard({Key key, @required this.routine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
          right: 20,
          bottom: 15,
        ),
        child: Material(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            elevation: 4,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(routine.imagePath,
                        width: 150, fit: BoxFit.fitHeight),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    children: [
                      Text(routine.muscleGroup),
                      Text(routine.routineName),
                      Text(routine.difficulty),
                    ],
                  ),
                ),
              ],
            )));
  }
}