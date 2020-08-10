import 'package:flutter/material.dart';

import 'package:protein_tracker/bloc/DailyProteinService.dart';
import 'package:protein_tracker/components/calendarWidget.dart';
import 'package:protein_tracker/model/dailyProtein.dart';
import 'package:protein_tracker/utils/AdMobUtils.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class CalendarScreen extends StatelessWidget {
  _calendarLabel({String text, Color color, bool ringShape = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          ringShape
              ? Ring(
                  color: color,
                )
              : Circle(
                  color: color,
                ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: WidgetUtils.appBarBackArrow(
            translatedText(
              "appbar_calendar",
              context,
            ),
            context),
        body: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder<List<DailyProtein>>(
                stream: dailyProteinServices.stream,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return CircularProgressIndicator();
                  }
                  return CalendarWidget(snapshot.data);
                }),
            Container(
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      _calendarLabel(
                          text: 'goal completed',
                          color: PrimaryColor,
                          ringShape: true),
                      _calendarLabel(text: 'current Day', color: DarkGreyColor),
                      _calendarLabel(
                          text: 'selected Day', color: SecondaryColor),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            AdMobUtils.admobBanner(size: "b")
          ],
        )));
  }
}

class Circle extends StatelessWidget {
  final Color color;
  Circle({this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      margin: EdgeInsets.symmetric(horizontal: 1.0),
      height: 20.0,
      width: 20.0,
    );
  }
}

class Ring extends StatelessWidget {
  final Color color;
  Ring({this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: color, width: 3)),
      margin: EdgeInsets.symmetric(horizontal: 1.0),
      height: 20.0,
      width: 20.0,
    );
  }
}