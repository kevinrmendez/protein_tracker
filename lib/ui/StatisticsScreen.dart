import 'package:flutter/material.dart';
import 'package:protein_tracker/bloc/DateService.dart';
import 'package:protein_tracker/bloc/ProteinListService.dart';
import 'package:protein_tracker/bloc/StatisticsService.dart';
import 'package:protein_tracker/components/proteinChart.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/utils/AdMobUtils.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/dateUtils.dart';
import 'package:protein_tracker/utils/fontStyle.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class StatisticsScreen extends StatelessWidget {
  StatisticsScreen({Key key}) : super(key: key) {
    initStatistics();
  }

  initStatistics() async {
    await statisticsService.initStatistics();
  }

  _statsDataRow({List<Widget> children, Color color = MediumLightGreyColor}) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: color,
        width: 1.0,
      ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }

  _statsData({String label, int data, String measurement = ""}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(children: [
        Text(
          label,
          style: TextStyle(color: DarkGreyColor, fontSize: 12),
        ),
        Row(
          children: <Widget>[
            Text(
              "$data",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              measurement,
              style: TextStyle(color: DarkGreyColor, fontSize: 12),
            )
          ],
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Monthly protein intake',
                style: AppFontStyle.title,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                dateService.currentMonthDate,
                style: AppFontStyle.subtitle,
              ),
              Container(
                  height: MediaQuery.of(context).size.height * .4,
                  // child: ProteinChart.withSampleData(),
                  child: ProteinChart.withData(
                      statisticsService.currentChartData)),
              Container(
                  margin: EdgeInsets.only(top: 15),
                  child: AdMobUtils.admobBanner()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                      child: Text(
                        'Statistics',
                        style: AppFontStyle.subtitle,
                      ),
                    ),
                    _statsDataRow(children: [
                      _statsData(
                          label: 'PROTEIN CONSUMED',
                          data: statisticsService.currentTotalProtein,
                          measurement: "gr"),
                      _statsData(
                          label: 'AVG PROTEIN CONSUMED',
                          data: statisticsService.currentAvgProtein,
                          measurement: "gr"),
                    ]),
                    _statsDataRow(color: Colors.transparent, children: [
                      _statsData(
                          label: 'CALORIES CONSUMED',
                          data: statisticsService.currentTotalProtein * 4,
                          measurement: "cal"),
                      _statsData(
                          label: 'AVG CALORIES CONSUMED',
                          data: statisticsService.currentAvgProtein * 4,
                          measurement: "cal"),
                    ])
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
