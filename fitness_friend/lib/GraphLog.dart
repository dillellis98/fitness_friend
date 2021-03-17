import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';

import 'model/GraphData.dart';

class GraphLog extends StatefulWidget {
  final List<GraphData> datalist;

  GraphLog(this.datalist);

  @override
  _GraphLogState createState() => _GraphLogState();
}


class _GraphLogState extends State<GraphLog> {

  @override
  Widget build(BuildContext context) {
    final fromDate = DateTime(2021, 03, 01);
    final toDate = DateTime.now();

    final date1 = DateTime.now().subtract(Duration(days: 2));
    final date2 = DateTime.now().subtract(Duration(days: 3));

    return Center(
      child: Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: BezierChart(
          fromDate: fromDate,
          bezierChartScale: BezierChartScale.WEEKLY,
          toDate: toDate,
          selectedDate: toDate,
          series: [
            BezierLine(
              label: "Duty",
              data: [
                DataPoint<DateTime>(value: 10, xAxis: DateTime(2021,03,14)),
                DataPoint<DateTime>(value: 50, xAxis: date2),
              ],
            ),
          ],
          config: BezierChartConfig(
            verticalIndicatorStrokeWidth: 3.0,
            verticalIndicatorColor: Colors.black26,
            showVerticalIndicator: true,
            verticalIndicatorFixedPosition: false,
            backgroundColor: Colors.red,
            footerHeight: 30.0,
          ),
        ),
      ),
    );
  }
}
