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
import 'package:protein_tracker/utils/localization_utils.dart';
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

  _statsData({String label, Stream data, String measurement = ""}) {
    return StreamBuilder(
        stream: data,
        builder: (context, snapshot) {
          var data = snapshot.data ?? 0;
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
        });
  }

  _statsDataCalories({String label, Stream data, String measurement = ""}) {
    return StreamBuilder(
        stream: data,
        builder: (context, snapshot) {
          var data = snapshot.data ?? 0;
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
                    "${data * 4}",
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
        });
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
                translatedText(
                  "statistics_title",
                  context,
                ),
                style: AppFontStyle.title,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                dateService.currentMonthDate,
                style: AppFontStyle.subtitle,
              ),
              StreamBuilder<List<TimeSeriesProtein>>(
                  stream: statisticsService.chartDataStream,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                          height: MediaQuery.of(context).size.height * .4,
                          child: Center(
                              child: SizedBox(
                                  child: CircularProgressIndicator())));
                    } else {
                      return Container(
                          height: MediaQuery.of(context).size.height * .4,
                          // child: ProteinChart.withSampleData(),
                          child: ProteinChart.withData(snapshot.data));
                    }
                  }),
              // Container(
              //     margin: EdgeInsets.only(top: 15),
              //     child: AdMobUtils.admobBanner()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                      child: Text(
                        translatedText(
                          "statistics_subtitle_statistics",
                          context,
                        ),
                        style: AppFontStyle.subtitle,
                      ),
                    ),
                    _statsDataRow(children: [
                      _statsData(
                          label: translatedText(
                            "statistics_label_protein_consumed",
                            context,
                          ),
                          data: statisticsService.totalProteinStream,
                          measurement: "gr"),
                      _statsData(
                          label: translatedText(
                            "statistics_label_protein_avg_consumed",
                            context,
                          ),
                          data: statisticsService.avgProteinStream,
                          measurement: "gr"),
                    ]),
                    _statsDataRow(color: Colors.transparent, children: [
                      _statsDataCalories(
                          label: translatedText(
                            "statistics_label_calories_consumed",
                            context,
                          ),
                          data: statisticsService.totalProteinStream,
                          measurement: "cal"),
                      _statsDataCalories(
                          label: translatedText(
                            "statistics_label_calories_avg_consumed",
                            context,
                          ),
                          data: statisticsService.avgProteinStream,
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
