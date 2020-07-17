import 'package:flutter/material.dart';
import 'package:protein_tracker/bloc/DateService.dart';
import 'package:protein_tracker/bloc/ProteinListService.dart';
import 'package:protein_tracker/components/proteinChart.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/dateUtils.dart';
import 'package:protein_tracker/utils/fontStyle.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class StatisticsScreen extends StatelessWidget {
  List monthlyProteins;
  List<TimeSeriesProtein> chartData = [];
  int totalProtein = 0;
  int avgProtein = 0;
  StatisticsScreen({Key key}) : super(key: key) {
    initStatistics();
  }

  initStatistics() async {
    await getMonthProteinFromDb();
    await getTotalProtein();
    getAvgProtein();
  }

  getMonthProteinFromDb() async {
    monthlyProteins = await proteinListServices.getMonthlyProtein(currentDate);
    chartData = getDailyTotalProtein(monthlyProteins);
  }

  getTotalProtein() {
    chartData.forEach((p) {
      totalProtein = totalProtein + p.proteinAmount;
    });
  }

  getAvgProtein() {
    var numberOfDays = chartData.length;
    avgProtein = (totalProtein / numberOfDays).round();
  }

  List<TimeSeriesProtein> getDailyTotalProtein(List monthlyProtein) {
    List<TimeSeriesProtein> dailyTotalProteinList = [];
    int dailyTotalProtein = 0;
    String proteinDateCache = "";
    int counter = 0;

    monthlyProteins.forEach((protein) {
      TimeSeriesProtein dailyProtein;
      String formattedDate = DateUtils.parseDate(protein.date);
      DateTime proteinDay = DateTime.parse(formattedDate);

      if (proteinDateCache == "") {
        proteinDateCache = protein.date;
        dailyTotalProtein = protein.amount;
      } else {
        if (proteinDateCache == protein.date) {
          dailyTotalProtein = dailyTotalProtein + protein.amount;
          counter++;
        } else {
          dailyProtein = TimeSeriesProtein(proteinDay, dailyTotalProtein);
          dailyTotalProteinList.add(dailyProtein);
          dailyTotalProtein = 0;
          counter = 0;
          proteinDateCache == protein.date;
        }
        if (dailyTotalProteinList.length == 0 &&
            counter == monthlyProteins.length - 1) {
          dailyProtein = TimeSeriesProtein(proteinDay, dailyTotalProtein);
          dailyTotalProteinList.add(dailyProtein);
        }
      }
    });
    return dailyTotalProteinList;
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
                  // child: ProteinChart.withSampleData()),
                  child: ProteinChart.withData(chartData)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                      child: Text(
                        'statistics',
                        style: AppFontStyle.subtitle,
                      ),
                    ),
                    _statsDataRow(children: [
                      _statsData(
                          label: 'PROTEIN CONSUMED',
                          data: totalProtein,
                          measurement: "gr"),
                      _statsData(
                          label: 'AVG PROTEIN CONSUMED',
                          data: avgProtein,
                          measurement: "gr"),
                    ]),
                    _statsDataRow(color: Colors.transparent, children: [
                      _statsData(
                          label: 'CALORIES CONSUMED',
                          data: totalProtein * 4,
                          measurement: "cal"),
                      _statsData(
                          label: 'AVG CALORIES CONSUMED',
                          data: avgProtein * 4,
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
