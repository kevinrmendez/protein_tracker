import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:protein_tracker/utils/theme_text.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

import '../../../model/dailyProtein.dart';
import '../../../model/protein_event.dart';
import '../../../utils/colors.dart';
import '../../../utils/dateUtils.dart';
import '../../../utils/localization_utils.dart';
import 'calendar_protein_dialog.dart';

class CalendarWidget extends StatefulWidget {
  final Color iconColors;
  final List<DailyProtein> dailyProteinList;
  final BuildContext context;
  CalendarWidget(this.dailyProteinList, this.context, this.iconColors);
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  // DateTime _currentDate = DateTime(2020, 2, 3);
  DateTime _currentDate = DateTime.now();
  String _currentMonth;
  // String _currentMonth = DateFormat.yMMM()
  //         .format(DateTime.now());
  CalendarCarousel _calendarCarouselNoHeader;

  DateTime _targetDateTime = DateTime.now();
  EventList<ProteinEvent> _markedDateMap;

//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  Widget _eventIcon() {
    return Container(
      decoration: BoxDecoration(
          color: widget.iconColors,
          borderRadius: BorderRadius.all(Radius.circular(1000)),
          border: Border.all(color: widget.iconColors, width: 2.0)),
      child: new Icon(
        Icons.check,
        color: Colors.white,
        size: 22,
      ),
    );
  }

  EventList<ProteinEvent> _transformDailyProteinListToEvenList(
      List<DailyProtein> dailyProteinList) {
    EventList<ProteinEvent> eventList = EventList<ProteinEvent>();
    if (dailyProteinList != null) {
      dailyProteinList.forEach((dailyProtein) {
        DateTime proteinDate =
            DateTime.parse(DateUtils.parseDate(dailyProtein.date));
        var event = _transformDailyProteinToEvent(dailyProtein);

        //check if they have completed their goal and add to event list
        if (dailyProtein.isGoalAchieved == 1) {
          eventList.add(proteinDate, event);
        }
      });
    }

    return eventList;
  }

  EventList<ProteinEvent> _getEventList() {
    var eventList =
        _transformDailyProteinListToEvenList(widget.dailyProteinList);
    return eventList;
  }

  ProteinEvent _transformDailyProteinToEvent(DailyProtein dailyProtein) {
    DateTime proteinDate =
        DateTime.parse(DateUtils.parseDate(dailyProtein.date));
    return ProteinEvent(
        date: proteinDate,
        title: dailyProtein.date,
        icon: _eventIcon(),
        goal: dailyProtein.goal,
        proteinConsumed: dailyProtein.totalProtein);
  }

  _getDailyProteinByDate(DateTime date) {
    print("date: $date");
    return widget.dailyProteinList.firstWhere(
        (element) => DateTime.parse(DateUtils.parseDate(element.date)) == date,
        orElse: () => null);
  }

  // EventList<Event> _markedDateMap = new EventList<Event>(
  //   events: {
  //     new DateTime(2020, 7, 7): [
  //       new Event(
  //         date: new DateTime(2020, 7, 7),
  //         title: 'Event 1',
  //         icon: _eventIcon,
  //         // dot: Container(
  //         //   margin: EdgeInsets.symmetric(horizontal: 1.0),
  //         //   color: Colors.red,
  //         //   height: 5.0,
  //         //   width: 5.0,
  //         // ),
  //       ),
  //     ],
  //   },
  // );

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList
    // _markedDateMap.add(
    //     new DateTime(2020, 7, 25),
    //     new Event(
    //       date: new DateTime(2020, 7, 25),
    //       title: 'Event 5',
    //       icon: _eventIcon,
    //     ));

    // _markedDateMap.add(
    //     new DateTime(2020, 7, 10),
    //     new Event(
    //       date: new DateTime(2020, 7, 10),
    //       title: 'Event 4',
    //       icon: _eventIcon,
    //     ));

    // _markedDateMap.add(
    //   new DateTime(2020, 7, 11),
    //   new Event(
    //     date: new DateTime(2020, 7, 11),
    //     title: 'Event 3',
    //     icon: _eventIcon,
    //   ),
    // );
    _currentMonth =
        DateFormat.yMMM(Localizations.localeOf(widget.context).languageCode)
            .format(DateTime.now());
    _markedDateMap = _getEventList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // / Example Calendar Carousel without header and custom prev & next button
    _calendarCarouselNoHeader = CalendarCarousel<ProteinEvent>(
      locale: Localizations.localeOf(context).languageCode,
      weekdayTextStyle:
          TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      todayBorderColor: DarkGreyColor,
      onDayPressed: (DateTime date, List<ProteinEvent> events) {
        // this.setState(() => _currentDate = date);
        // events.forEach((event) => print(event.title));
        DailyProtein dailyProteinSelected = _getDailyProteinByDate(date);
        print("${dailyProteinSelected.toString()}");
        print('day pressed ${date.toString()}');

        if (dailyProteinSelected != null) {
          showDialog(
              context: context,
              builder: (_) => CalendarProteinDialog(dailyProteinSelected));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return WidgetUtils.dialog(
                    context: context,
                    // title: widget.event.title,
                    title: '',
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Selected date has no data',
                                  style: ThemeText.dialogHeader,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Wrap(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                WidgetUtils.button(context,
                                    fontSize: 16,
                                    text: translatedText(
                                      "button_close",
                                      context,
                                    ),
                                    color: DarkGreyColor, onPressed: () {
                                  Navigator.pop(context);
                                })
                              ],
                            )
                          ]),
                        ],
                      ),
                    ));
              });
        }
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.black,
      ),
      // thisMonthDayBorderColor: Colors.black,
      weekFormat: false,
      // firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      // height: 420.0,
      height: MediaQuery.of(context).size.height * .42,
      selectedDateTime: _currentDate,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      // markedDateCustomTextStyle:
      //     TextStyle(fontWeight: FontWeight.bold, color: PrimaryColor),
      markedDateCustomShapeBorder:
          CircleBorder(side: BorderSide(color: widget.iconColors, width: 3)),
      // markedDateCustomTextStyle: TextStyle(
      //   fontSize: 18,
      //   color: Colors.blue,
      // ),
      selectedDayButtonColor: BackgroundColor,
      selectedDayBorderColor: BackgroundColor,
      selectedDayTextStyle: TextStyle(color: Colors.black),
      // selectedDayButtonColor: SecondaryColor,
      // selectedDayBorderColor: SecondaryColor,
      showHeader: false,

      todayTextStyle: TextStyle(
        color: Colors.white,
      ),
      markedDateShowIcon: true,
      // markedDateIconMaxShown: 2,
      // markedDateIconBuilder: (event) {
      //   return event.icon;
      // },
      // markedDateMoreShowTotal: true,
      todayButtonColor: DarkGreyColor,
      // selectedDayTextStyle: TextStyle(
      //   color: Colors.white,
      // ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: DarkMediumGreyColor,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.red[300],
        fontSize: 16,
      ),

      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth =
              DateFormat.yMMM(Localizations.localeOf(context).languageCode)
                  .format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        //custom icon without header
        Container(
          margin: EdgeInsets.only(
            top: 20.0,
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          child: new Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                _currentMonth,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              )),
              FlatButton(
                child: Text(translatedText(
                  "calendar_label_prev",
                  context,
                )),
                onPressed: () {
                  setState(() {
                    _targetDateTime = DateTime(
                        _targetDateTime.year, _targetDateTime.month - 1);
                    _currentMonth = DateFormat.yMMM(
                            Localizations.localeOf(context).languageCode)
                        .format(_targetDateTime);
                  });
                },
              ),
              FlatButton(
                child: Text(translatedText(
                  "calendar_label_next",
                  context,
                )),
                onPressed: () {
                  setState(() {
                    _targetDateTime = DateTime(
                        _targetDateTime.year, _targetDateTime.month + 1);
                    _currentMonth = DateFormat.yMMM(
                            Localizations.localeOf(context).languageCode)
                        .format(_targetDateTime);
                  });
                },
              )
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .42,
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: _calendarCarouselNoHeader,
        ), //
      ],
    );
  }
}
