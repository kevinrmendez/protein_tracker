import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:protein_tracker/utils/localization_utils.dart';

class DateUtils {
  static String parseDate(String date) {
    String formattedString = "";
    if (date.contains('January')) {
      formattedString = date.replaceFirst('January', '01');
    }
    if (date.contains('February')) {
      formattedString = date.replaceFirst('February', '02');
    }
    if (date.contains('March')) {
      formattedString = date.replaceFirst('March', '03');
    }
    if (date.contains('April')) {
      formattedString = date.replaceFirst('April', '04');
    }
    if (date.contains('May')) {
      formattedString = date.replaceFirst('May', '05');
    }
    if (date.contains('June')) {
      formattedString = date.replaceFirst('June', '06');
    }
    if (date.contains('July')) {
      formattedString = date.replaceFirst('July', '07');
    }
    if (date.contains('August')) {
      formattedString = date.replaceFirst('August', '08');
    }
    if (date.contains('September')) {
      formattedString = date.replaceFirst('September', '09');
    }
    if (date.contains('October')) {
      formattedString = date.replaceFirst('October', '10');
    }
    if (date.contains('November')) {
      formattedString = date.replaceFirst('November', '11');
    }
    if (date.contains('December')) {
      formattedString = date.replaceFirst('December', '12');
    }
    var formattedStringList = formattedString.split("-");
    formattedStringList = formattedStringList.reversed.toList();
    formattedString = formattedStringList.join("-");
    return formattedString;
  }

  static bool hasDateChanged(String date1, String date2) {
    String day1String, day2String;
    int day1, day2;
    day1String = date1.substring(0, 1);
    day2String = date2.substring(0, 1);
    print('TESTIING');
    print(day1String);
    print(day2String);
    day1 = int.parse(day1String);
    day2 = int.parse(day2String);

    return day1 != day2;
  }

  static String formattedToday() {
    var today = DateTime.now();

    DateFormat formatter = DateFormat('dd-MMMM-yyyy');

    return formatter.format(today);
  }

  static String getMonthName(int month, BuildContext context) {
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
}
