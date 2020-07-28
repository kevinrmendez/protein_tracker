import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:protein_tracker/bloc/FoodService.dart';
import 'package:protein_tracker/bloc/ProteinListService.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/bloc/StatisticsService.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/model/protein.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:protein_tracker/utils/localization_utils.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentDate = DateTime(2020, 2, 3);
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: PrimaryColor,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: PrimaryColor, width: 2.0)),
    child: new Icon(
      Icons.check,
      color: Colors.white,
      size: 22,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2020, 7, 7): [
        new Event(
          date: new DateTime(2020, 7, 7),
          title: 'Event 1',
          icon: _eventIcon,
          // dot: Container(
          //   margin: EdgeInsets.symmetric(horizontal: 1.0),
          //   color: Colors.red,
          //   height: 5.0,
          //   width: 5.0,
          // ),
        ),
      ],
    },
  );

  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList
    _markedDateMap.add(
        new DateTime(2020, 7, 25),
        new Event(
          date: new DateTime(2020, 7, 25),
          title: 'Event 5',
          icon: _eventIcon,
        ));

    _markedDateMap.add(
        new DateTime(2020, 7, 10),
        new Event(
          date: new DateTime(2020, 7, 10),
          title: 'Event 4',
          icon: _eventIcon,
        ));

    _markedDateMap.add(
      new DateTime(2020, 7, 11),
      new Event(
        date: new DateTime(2020, 7, 11),
        title: 'Event 3',
        icon: _eventIcon,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//     _calendarCarousel = CalendarCarousel<Event>(
//       onDayPressed: (DateTime date, List<Event> events) {
//         this.setState(() => _currentDate = date);
//         events.forEach((event) => print(event.title));
//       },
//       weekendTextStyle: TextStyle(
//         color: Colors.red,
//       ),
//       thisMonthDayBorderColor: Colors.grey,
// //          weekDays: null, /// for pass null when you do not want to render weekDays
//       headerText: 'Weekly',
//       weekFormat: true,
//       markedDatesMap: _markedDateMap,
//       height: 200.0,
//       selectedDateTime: _currentDate2,
//       showIconBehindDayText: true,
// //          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
//       customGridViewPhysics: NeverScrollableScrollPhysics(),
//       markedDateShowIcon: true,
//       markedDateIconMaxShown: 2,
//       selectedDayTextStyle: TextStyle(
//         color: Colors.yellow,
//       ),
//       todayTextStyle: TextStyle(
//         color: Colors.blue,
//       ),
//       markedDateIconBuilder: (event) {
//         return event.icon;
//       },
//       minSelectedDate: _currentDate.subtract(Duration(days: 360)),
//       maxSelectedDate: _currentDate.add(Duration(days: 360)),
//       todayButtonColor: Colors.transparent,
//       todayBorderColor: Colors.green,
//       markedDateMoreShowTotal:
//           true, // null for not showing hidden events indicator
// //          markedDateIconMargin: 9,
// //          markedDateIconOffset: 3,
//     );

    /// Example Calendar Carousel without header and custom prev & next button
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      weekdayTextStyle:
          TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      todayBorderColor: DarkGreyColor,
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));
        print('day pressed');
        showDialog(context: context, builder: (_) => AddProteinDialog());
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
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      // markedDateCustomTextStyle:
      //     TextStyle(fontWeight: FontWeight.bold, color: PrimaryColor),
      markedDateCustomShapeBorder:
          CircleBorder(side: BorderSide(color: PrimaryColor, width: 3)),
      // markedDateCustomTextStyle: TextStyle(
      //   fontSize: 18,
      //   color: Colors.blue,
      // ),
      selectedDayButtonColor: SecondaryColor,
      selectedDayBorderColor: SecondaryColor,
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
      selectedDayTextStyle: TextStyle(
        color: Colors.white,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: MediumGreyColor,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return new Scaffold(
        appBar: WidgetUtils.appBarBackArrow('calendar', context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //custom icon
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 16.0),
              //   child: _calendarCarousel,
              // ), // This trailing comma makes auto-formatting nicer for build methods.
              //custom icon without header
              Container(
                margin: EdgeInsets.only(
                  top: 30.0,
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
                        fontSize: 32.0,
                      ),
                    )),
                    FlatButton(
                      child: Text('PREV'),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month - 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    ),
                    FlatButton(
                      child: Text('NEXT'),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month + 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: _calendarCarouselNoHeader,
              ), //
            ],
          ),
        ));
  }
}

class AddProteinDialog extends StatefulWidget {
  @override
  _AddProteinDialogState createState() => _AddProteinDialogState();
}

class _AddProteinDialogState extends State<AddProteinDialog> {
  final _formKey = GlobalKey<FormState>();

  String dropdownValueGoal;
  String foodName;
  int proteinAmount;
  final _foodNameController = TextEditingController();
  final _proteinAmountController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
        context: context,
        height: MediaQuery.of(context).size.height * .56,
        title: translatedText(
          "tracker_dialog_title_add_protein",
          context,
        ),
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(children: [
                  Row(
                    children: <Widget>[Text('goal: '), Text('84 gr')],
                  ),
                  Row(
                    children: <Widget>[
                      Text('protein consumed: '),
                      Text('150 gr')
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      WidgetUtils.button(context,
                          text: translatedText(
                            "button_edit",
                            context,
                          ),
                          color: DarkGreyColor, onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          print('add food');
                          print(foodName);
                          print(proteinAmount);
                          DateTime now = DateTime.now();
                          final DateFormat formatter =
                              DateFormat('dd-MMMM-yyyy');
                          final String formattedDateNow = formatter.format(now);
                          Protein protein = Protein(
                              name: foodName,
                              amount: proteinAmount,
                              date: formattedDateNow);

                          proteinListServices.add(protein);
                          proteinService.updateConsumedProtein();
                          statisticsService.updateStatisticsData();

                          Navigator.pop(context);
                        } else {}
                      }),
                      WidgetUtils.button(context,
                          text: translatedText(
                            "button_close",
                            context,
                          ),
                          color: DarkGreyColor, onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          DateTime now = DateTime.now();
                          final DateFormat formatter =
                              DateFormat('dd-MMMM-yyyy');
                          final String formattedDateNow = formatter.format(now);
                          Protein protein = Protein(
                              name: foodName,
                              amount: proteinAmount,
                              date: formattedDateNow);

                          proteinListServices.add(protein);
                          proteinService.updateConsumedProtein();
                          statisticsService.updateStatisticsData();

                          Navigator.pop(context);
                        } else {}
                      })
                    ],
                  )
                ]),
              ),
            ],
          ),
        ));
  }
}
