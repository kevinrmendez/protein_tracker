import 'package:flutter/material.dart';

import 'package:protein_tracker/bloc/DailyProteinService.dart';
import 'package:protein_tracker/components/calendarWidget.dart';
import 'package:protein_tracker/model/dailyProtein.dart';
import 'package:protein_tracker/utils/AdMobUtils.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class CalendarScreen extends StatelessWidget {
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
                  Text('goal completed'),
                  Text('current day'),
                  Text('selected day'),
                ],
              ),
            ),
            AdMobUtils.admobBanner(size: "b")
          ],
        )));
  }
}
