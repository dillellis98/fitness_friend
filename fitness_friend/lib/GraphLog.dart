import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';

import 'model/GraphData.dart';

class GraphLog extends StatefulWidget {
  final List<GraphData> cleanedData;

  GraphLog(this.cleanedData);

  @override
  _GraphLogState createState() => _GraphLogState();
}

class _GraphLogState extends State<GraphLog> {
  List<DataPoint> makeDataPoints() {
    List<DataPoint> dataPointList = [];
    for (int i = 0; i < widget.cleanedData.length; i++) {
      //print("DATA HERE : ${widget.cleanedData[i].weight} + ${widget.cleanedData[i].logtime}");
      dataPointList.add(DataPoint<DateTime>(
          value: widget.cleanedData[i].weight.toDouble(),
          xAxis: DateTime.parse(widget.cleanedData[i].logtime)));
    }

    return dataPointList;
  }

  @override
  Widget build(BuildContext context) {
    final fromDate =DateTime.now().subtract(Duration(days: 30));
    final toDate = DateTime.now();

    return Center(
      child: Container(
        color: Color(0xff68D065),
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: BezierChart(
          fromDate: fromDate,
          bezierChartScale: BezierChartScale.WEEKLY,
          toDate: toDate.add(Duration(days: 1)),
          selectedDate: toDate,
          series: [
            BezierLine(
              label: "KG",
              data: makeDataPoints(),
            ),
          ],
          config: BezierChartConfig(
            displayDataPointWhenNoValue: false,
            verticalIndicatorStrokeWidth: 3.0,
            verticalIndicatorColor: Colors.black26,
            showVerticalIndicator: true,
            verticalIndicatorFixedPosition: false,
            backgroundColor: Color(0xff68D065),
            footerHeight: 30.0,
            showDataPoints: true,
          ),
        ),
      ),
    );
  }
}
