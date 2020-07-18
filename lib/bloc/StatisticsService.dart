import 'package:intl/intl.dart';
import 'package:protein_tracker/bloc/ProteinListService.dart';
import 'package:protein_tracker/components/proteinChart.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/model/protein.dart';
import 'package:protein_tracker/repository/protein_repository.dart';
import 'package:protein_tracker/utils/dateUtils.dart';
import 'package:rxdart/rxdart.dart';

class StatisticsService {
  BehaviorSubject _totalProtein = BehaviorSubject.seeded(0);
  BehaviorSubject _avgProtein = BehaviorSubject.seeded(0);
  BehaviorSubject _chartData = BehaviorSubject.seeded([]);
  ProteinRepository _proteinRepository = ProteinRepository();

  Stream get totalProteinStream => _totalProtein.stream;
  Stream get avgProteinStream => _avgProtein.stream;
  Stream get chartDataStream => _chartData.stream;

  int get currentTotalProtein => _totalProtein.value;
  int get currentAvgProtein => _avgProtein.value;
  List<TimeSeriesProtein> get currentChartData => _chartData.value;

  StatisticsService() {
    initStatistics();
  }

  initStatistics() async {
    await getMonthProteinFromDb();
    await _getTotalProtein();
    getAvgProtein();
  }

  getMonthProteinFromDb() async {
    List<Protein> monthlyProteins = await _getMonthlyProtein(currentDate);
    getDailyTotalProtein(monthlyProteins);
  }

  Future<List<Protein>> _getMonthlyProtein(DateTime date) async {
    var now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM');
    var monthName = formatter.format(now);
    formattedDateNow = formatter.format(date);

    List monthlyProteins =
        await _proteinRepository.getAllProteins(query: monthName);
    return monthlyProteins;
  }

  _getTotalProtein() {
    int totalProtein = 0;
    List<TimeSeriesProtein> chartData = currentChartData;
    chartData.forEach((p) {
      totalProtein = totalProtein + p.proteinAmount;
    });
    _totalProtein.add(totalProtein);
  }

  getAvgProtein() {
    List<TimeSeriesProtein> chartData = currentChartData;
    int totalProtein = currentTotalProtein;
    int numberOfDays = chartData.length;
    int avgProtein = (totalProtein / numberOfDays).round();

    _avgProtein.add(avgProtein);
  }

  getDailyTotalProtein(List monthlyProtein) {
    List<TimeSeriesProtein> dailyTotalProteinList = [];
    int dailyTotalProtein = 0;
    String proteinDateCache = "";
    int counter = 0;

    monthlyProtein.forEach((protein) {
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
          if (dailyTotalProtein == 0) {
            dailyTotalProtein = protein.amount;
          }
          dailyProtein = TimeSeriesProtein(proteinDay, dailyTotalProtein);
          dailyTotalProteinList.add(dailyProtein);
          proteinDateCache = protein.date;
          dailyTotalProtein = 0;
          counter = 0;
        }
        if (dailyTotalProteinList.length == 0 &&
            counter == monthlyProtein.length - 1) {
          dailyProtein = TimeSeriesProtein(proteinDay, dailyTotalProtein);
          dailyTotalProteinList.add(dailyProtein);
        }
      }
    });
    _chartData.add(dailyTotalProteinList);
  }

  updateStatisticsData() async {
    await getMonthProteinFromDb();
    await _getTotalProtein();
    getAvgProtein();
  }
}

StatisticsService statisticsService = StatisticsService();
