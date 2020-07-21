import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/repository/food_repository.dart';

import 'package:rxdart/rxdart.dart';

class DateService {
  BehaviorSubject<DateTime> _date = BehaviorSubject.seeded(DateTime.now());
  BehaviorSubject<int> _month = BehaviorSubject.seeded(0);

  Stream get stream => _date.stream;
  Stream get streamMonth => _month.stream;

  DateTime get currentDate => _date.value;
  int get currentMonthDate => _month.value;

  updateDate(DateTime date) async {
    _date.add(date);
  }

  updateDateMonth(DateTime date) async {
    // List months = [
    //   'January',
    //   'February',
    //   'March',
    //   'April',
    //   'May',
    //   'June',
    //   'July',
    //   'August',
    //   'September',
    //   'October',
    //   'November',
    //   'December'
    // ];
    var month = date.month;
    // var month = months[date.month - 1];
    // print(month);
    // print(date.month.toString());
    _month.add(month);
  }
}

DateService dateService = DateService();
