import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:math';
import 'database_helper.dart';
import 'line_chart.dart';
import 'package:flutter/material.dart';
import 'graphLog.dart';

import 'model/GraphData.dart';
import 'model/exercise.dart';
import 'model/exerciseLog.dart';

class InfoCard extends StatefulWidget {
  final String title;
  final int eid;
  final int uid;

  const InfoCard(
    this.title,
    this.eid,
    this.uid,
  );

  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  List<Exercise> allExercises;

  getExerciseList() async {
    allExercises = await DatabaseHelper.instance.getExercises();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Color(0xff68D065),
      onTap: () async {
        List<ExerciseLog> loglist = await DatabaseHelper.instance
            .getExerciseLogGraph(widget.eid, widget.uid);
        List<GraphData> data = [];

        for (int i = 0; i < loglist.length; i++) {
          data.add(new GraphData(loglist[i].weight, loglist[i].logdate));
          //print("DATA: ${loglist[i].weight}, ${loglist[i].logID}");
        }

        List<GraphData> cleanedData = [];
        var tempWeight = data.first.weight;
        var tempDate = data.first.logtime;

        print("next");
        data.forEach((element) {
          print("${element.weight}");
          if (element.logtime == tempDate) {
            if (element.weight >= tempWeight) {
              //print("temp weight is $tempWeight");
              tempWeight = element.weight;
              tempDate = element.logtime;
              //print("new temp weight is $tempWeight");
            }
          }
          if (element.logtime != tempDate || element == data.last ) {
            cleanedData.add(new GraphData(tempWeight, tempDate));
            tempWeight = 0;
            tempDate = element.logtime;
          }
        });

        // cleanedData.forEach((element) {
        //   print("cleaned data is ${element.weight}, ${element.logtime}");
        // });

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => GraphLog(cleanedData)));
      },
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.dumbbell,
                      color: Color(0xff68D065),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${widget.eid}\n",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: LineReportChart(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
