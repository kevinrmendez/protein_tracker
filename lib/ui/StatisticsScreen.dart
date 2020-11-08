import 'package:flutter/material.dart';

import '../bloc/DateService.dart';
import '../bloc/StatisticsService.dart';
import '../components/proteinChart.dart';
import '../utils/AdMobUtils.dart';
import '../utils/colors.dart';
import '../utils/fontStyle.dart';
import '../utils/localization_utils.dart';
import '../utils/widgetUtils.dart';

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

  _statsLabel({String text, BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width * .4,
      child: Expanded(
        child: Text(
          text,
          style: TextStyle(color: DarkGreyColor, fontSize: 12),
        ),
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
              _statsLabel(text: label, context: context),
              Row(
                children: <Widget>[
                  Text(
                    "$data",
                    textAlign: TextAlign.center,
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
              _statsLabel(text: label, context: context),
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
    String _getMonthName(int month) {
      switch (month) {
        case 1:
          {
            return translatedText(
              "monthName_01",
              context,
            );
          }
        case 2:
          {
            return translatedText(
              "monthName_02",
              context,
            );
          }
        case 3:
          {
            return translatedText(
              "monthName_03",
              context,
            );
          }
        case 4:
          {
            return translatedText(
              "monthName_04",
              context,
            );
          }
        case 5:
          {
            return translatedText(
              "monthName_05",
              context,
            );
          }
        case 6:
          {
            return translatedText(
              "monthName_06",
              context,
            );
          }
        case 7:
          {
            return translatedText(
              "monthName_07",
              context,
            );
          }
        case 8:
          {
            return translatedText(
              "monthName_08",
              context,
            );
          }
        case 9:
          {
            return translatedText(
              "monthName_09",
              context,
            );
          }
        case 10:
          {
            return translatedText(
              "monthName_10",
              context,
            );
          }
        case 11:
          {
            return translatedText(
              "monthName_11",
              context,
            );
          }
        case 12:
          {
            return translatedText(
              "monthName_12",
              context,
            );
          }

          break;
        default:
      }
    }

    return ListView(children: [
      WidgetUtils.screenTitle(
          title: translatedText("statistics_title", context), context: context),
      Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                _getMonthName(dateService.currentMonthDate),
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
              SizedBox(
                height: 10,
              ),
              AdMobUtils.admobBanner(),
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
