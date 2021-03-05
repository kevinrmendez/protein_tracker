import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protein_tracker/application/DailyProteinService.dart';
import 'package:protein_tracker/model/dailyProtein.dart';
import 'package:protein_tracker/utils/localization_utils.dart';

class ExportDataService {
  static void exportDataToEmail(
      {String emailBody = '', String emailSubject = ''}) async {
    var filePath = await _exportData();
    _sendEmail(emailBody, emailSubject, filePath);
  }

  static Future<String> _exportData() async {
    Directory dir = await getExternalStorageDirectory();
    String path = dir.absolute.path;
    print(path);
    File file = File('$path/protein.csv');
    List<DailyProtein> dailyProtein = dailyProteinServices.currentList;
    List<List<dynamic>> rows = List<List<dynamic>>();
    for (int i = 0; i < dailyProtein.length; i++) {
      if (i == 0) {
        List<dynamic> header = List();
        header.add("");
        header.add("date");
        header.add("goal");
        header.add("daily protein");
        header.add("goal achieved");
        rows.add(header);
      }
      List<dynamic> row = List();
      row.add(dailyProtein[i].id);
      row.add(dailyProtein[i].date);
      row.add(dailyProtein[i].goal);
      row.add(dailyProtein[i].totalProtein);
      row.add(dailyProtein[i].isGoalAchieved == 1 ? "yes" : "no");
      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows);

    file.writeAsString(csv);
    String filePath = '$path/protein.csv';

    filePath = file.path;
    return filePath;
  }

  static _sendEmail(String body, String subject, String filePath) async {
    final Email email = Email(body: body, subject: subject,
        // recipients: ['example@example.com'],
        attachmentPaths: [filePath]);
    print("FILEPATHS: ${filePath.toString()}");
    await FlutterEmailSender.send(email);
    print('file email sended');
  }
}
