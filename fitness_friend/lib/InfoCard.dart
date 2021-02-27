import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'line_chart.dart';
import 'package:flutter/material.dart';


class InfoCard extends StatelessWidget {
  final String title;
  final int effectedNum;
  final Function press;
  const InfoCard({
    Key key,
    this.title,
    this.effectedNum,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: press,
          child: Container(
            width: constraints.maxWidth / 2 - 10,
            // Here constraints.maxWidth provide us the available width for the widget
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        // wrapped within an expanded widget to allow for small density device
                        Expanded(
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Color(0xff284FC2).withOpacity(0.5) ,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(FontAwesomeIcons.dumbbell),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          title,
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
                                  text: "$effectedNum \n",
                                  style:
                                  Theme.of(context).textTheme.headline6.copyWith(
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
      },
    );
  }
}