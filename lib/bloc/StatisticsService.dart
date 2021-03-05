import 'package:intl/intl.dart';
import 'package:protein_tracker/bloc/ProteinListService.dart';
import 'package:protein_tracker/presentation/statistics_screen/widgets/proteinChart.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/model/proteins/protein.dart';
import 'package:protein_tracker/repository/protein_repository.dart';
import 'package:protein_tracker/utils/dateUtils.dart';
import 'package:rxdart/rxdart.dart';

class StatisticsService {
  BehaviorSubject _totalProtein = BehaviorSubject.seeded(0);
  BehaviorSubject _avgProtein = BehaviorSubject.seeded(0);
  BehaviorSubject<List<TimeSeriesProtein>> _chartData =
      BehaviorSubject.seeded([]);
  ProteinRepository _proteinRepository = ProteinRepository();

  Stream get totalProteinStream => _totalProtein.stream;
  Stream get avgProteinStream => _avgProtein.stream;
  Stream<List<TimeSeriesProtein>> get chartDataStream => _chartData.stream;

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
    int index = 0;

    monthlyProtein.forEach((protein) {
      TimeSeriesProtein dailyProtein;
      String formattedDate = DateUtils.parseDate(protein.date);
      DateTime proteinDay = DateTime.parse(formattedDate);

      if (proteinDateCache == "") {
        proteinDateCache = protein.date;
        dailyTotalProtein = protein.amount;
      } else {
        //add protein with same day
        if (proteinDateCache == protein.date) {
          dailyTotalProtein = dailyTotalProtein + protein.amount;
          counter++;
          //add the protein to the list if date is different
        } else {
          if (dailyTotalProtein == 0) {
            dailyTotalProtein = protein.amount;
          }
          var date = DateUtils.parseDate(proteinDateCache);
          DateTime formattedDate = DateTime.parse(date);
          dailyProtein = TimeSeriesProtein(formattedDate, dailyTotalProtein);
          dailyTotalProteinList.add(dailyProtein);
          proteinDateCache = protein.date;
          dailyTotalProtein = protein.amount;
          counter = 0;
        }
      }
      //add the first day with protein if chart is empty
      if (dailyTotalProteinList.length == 0 &&
          counter == monthlyProtein.length - 1) {
        dailyProtein = TimeSeriesProtein(proteinDay, dailyTotalProtein);
        dailyTotalProteinList.add(dailyProtein);
      }
      index++;
      //add latest day with protein
      if (monthlyProtein.length == index) {
        dailyProtein = TimeSeriesProtein(proteinDay, dailyTotalProtein);
        dailyTotalProteinList.add(dailyProtein);
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
