import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/DailyProteinService.dart';
import '../../model/dailyProtein.dart';
import '../../utils/AdMobUtils.dart';
import '../../utils/colors.dart';
import '../../utils/localization_utils.dart';
import '../../utils/widgetUtils.dart';
import 'widgets/calendarWidget.dart';
import 'package:protein_tracker/application/settings/settings_bloc.dart';

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
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      var _calendarColor =
          state.isDarkModeEnabled ? PrimaryColor : BackgroundColor;
      var _iconColor = state.isDarkModeEnabled ? SecondaryColor : PrimaryColor;
      return SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          WidgetUtils.screenTitle(
              title: translatedText(
                "calendar_title",
                context,
              ),
              context: context),
          StreamBuilder<List<DailyProtein>>(
              stream: dailyProteinServices.stream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                      height: MediaQuery.of(context).size.height * .55,
                      child: Center(child: CircularProgressIndicator()));
                }
                return Container(
                    color: _calendarColor,
                    child: CalendarWidget(snapshot.data, context, _iconColor));
              }),
          SizedBox(
            height: 10,
          ),
          AdMobUtils.admobBanner(),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _calendarLabel(
                        text: translatedText(
                          "calendar_label_goal_completed",
                          context,
                        ),
                        color: _iconColor,
                        ringShape: true),
                    _calendarLabel(
                        text: translatedText(
                          "calendar_label_current_day",
                          context,
                        ),
                        color: DarkGreyColor),
                    // _calendarLabel(
                    //     text: translatedText(
                    //       "calendar_label_selected_day",
                    //       context,
                    //     ),
                    //     color: SecondaryColor),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ));
    });
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
          // color: Colors.white,
          border: Border.all(color: color, width: 3)),
      margin: EdgeInsets.symmetric(horizontal: 1.0),
      height: 20.0,
      width: 20.0,
    );
  }
}
