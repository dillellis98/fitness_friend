import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ExercisePicker.dart';
import 'InfoCard.dart';

import 'FoodLog.dart';
import 'LoginPage.dart';
import 'database_helper.dart';
import 'model/User.dart';
import 'model/exercise.dart';

class ProfilePage extends StatefulWidget {
  final int uid;

  ProfilePage(this.uid);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Exercise> allExercises;
  List<Exercise> graphList;
  var username;
  var userHeight;
  var userWeight;
  var goals;

  bool isLoading = true;

  getExerciseList() async {
    allExercises = await DatabaseHelper.instance.getExercises();
  }

  getgraph() async {
    graphList = await DatabaseHelper.instance.getGraphExercises();
  }


  getuserdetails() async {
    username = await DatabaseHelper.instance.getUserName(widget.uid);
    userHeight = await DatabaseHelper.instance.getUserHeight(widget.uid);
    userWeight = await DatabaseHelper.instance.getUserWeight(widget.uid);
    goals = await DatabaseHelper.instance.getUserGoal(widget.uid);
  }



  asyncMethod() async {
    await getgraph();
    await getuserdetails();
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
          ));
    }


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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/logo.png',
                      width: width * 0.3,
                      height: height * 0.3,
                    ),
                    Text(
                      "$username",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
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
            bottom: 0.5,
            child: Column(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: EdgeInsets.symmetric(
                      horizontal: height * 0.025, vertical: height * 0.0125),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white,
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Height",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("$userHeight",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Weight",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "$userWeight",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Goal",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("$goals",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: height * 0.06,
                  color: Colors.white,
                  child: ElevatedButton(
                    onPressed: () async {
                      await getExerciseList();
                      Exercise picked = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExercisePicker(
                                  "nothing", "nothing", false, allExercises)));

                      print("${picked.exerciseName}");
                      graphList.add(picked);

                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xff68D065))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // wrapped within an expanded widget to allow for small density device
                        Container(
                          height: 30,
                          width: 30,
                          child: Icon(FontAwesomeIcons.chartLine),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Text(
                          "Graph Exercise",
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: height * 0.55,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                graphList == null ?
                Center(
                    heightFactor: 7.5,
                    child:Text("Empty, please add a Graph",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                      textAlign: TextAlign.center,)
                ) :
                Container(
                  height: height * 0.4,
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  width: double.infinity,
                  child: GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5 / 2,
                      crossAxisSpacing: width * 0.03,
                      mainAxisSpacing: height * 0.02,
                    ),
//                    scrollDirection: Axis.vertical,
//                  child: Wrap(
//                    runSpacing: height * 0.02,
//                    spacing: width * 0.03,
                    itemBuilder: (BuildContext context, int index) {
                      Exercise exercise = graphList[index];
                      return InfoCard(exercise.exerciseName, exercise.exerciseID, widget.uid);
                    },
                    itemCount: graphList.length,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: height * 0.01,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: Color(0xff68D065),
                child: Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
