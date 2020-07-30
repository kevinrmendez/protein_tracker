import 'package:flutter/material.dart';

import 'package:protein_tracker/bloc/DailyProteinService.dart';
import 'package:protein_tracker/components/calendarWidget.dart';
import 'package:protein_tracker/model/dailyProtein.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: WidgetUtils.appBarBackArrow('calendar', context),
        body: SingleChildScrollView(
            child: StreamBuilder<List<DailyProtein>>(
                stream: dailyProteinServices.stream,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return CircularProgressIndicator();
                  }
                  return CalendarWidget(snapshot.data);
                })));
  }
}
