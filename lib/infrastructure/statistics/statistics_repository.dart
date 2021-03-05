import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:protein_tracker/domain/proteins/protein.dart';
import 'package:protein_tracker/infrastructure/proteins/protein_entity.dart';
import 'package:protein_tracker/domain/statistics/time_series_protein.dart';

@LazySingleton()
class StatisticsRepitory {
  Future<List<Protein>> _getMonthlyProtein(DateTime date) async {
    // var now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM');
    // var monthName = formatter.format(now);
    final Box<ProteinEntity> box = Hive.box('proteinEntity');
    box.values.forEach((element) {
      print(element.date);
    });
    List<Protein> monthlyproteinList = box.values
        .map((e) => Protein.fromEntity(e))
        .where((element) => element.date.contains(formatter.format(date)))
        .toList();

    print("MONTH");
    print(formatter.format(date));
    monthlyproteinList.forEach((element) {
      print(element.date);
    });
    return Future.value(monthlyproteinList);
    //   List monthlyProteins =
    //       await
    //   return monthlyProteins;
  }

  // ignore: non_constant_identifier_names
  List<TimeSeriesProtein> _mapProteinToTimeSeriesProtein(
      List<Protein> proteinList) {
    return proteinList.map((protein) => TimeSeriesProtein(
        DateFormat('dd-MMMM-yyyy').parse(protein.date), protein.amount));
  }

  Future<List<TimeSeriesProtein>> getMonthlyProteinData(
      List<Protein> proteinList) async {
    var now = DateTime.now();
    var monthlyProtein = await _getMonthlyProtein(now);
    print('DATA CHART ${monthlyProtein.length}');

    return _mapProteinToTimeSeriesProtein(monthlyProtein);
  }

  // _getTotalProtein() {
  //   int totalProtein = 0;
  //   List<TimeSeriesProtein> chartData = currentChartData;
  //   chartData.forEach((p) {
  //     totalProtein = totalProtein + p.proteinAmount;
  //   });
  //   _totalProtein.add(totalProtein);
  // }

  // getAvgProtein() {
  //   List<TimeSeriesProtein> chartData = currentChartData;
  //   int totalProtein = currentTotalProtein;
  //   int numberOfDays = chartData.length;
  //   int avgProtein = (totalProtein / numberOfDays).round();

  //   _avgProtein.add(avgProtein);
  // }
}
