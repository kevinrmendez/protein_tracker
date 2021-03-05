import 'package:intl/intl.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/domain/dailyProtein.dart';
import 'package:protein_tracker/repository/daily_protein_repository.dart';
import 'package:rxdart/rxdart.dart';

class DailyProteinService {
  static List<DailyProtein> dbProteins = [];
  final DailyProteinRepository _dailyProteinRepository =
      DailyProteinRepository();

  BehaviorSubject<List<DailyProtein>> _dailyProteinList =
      BehaviorSubject.seeded(<DailyProtein>[]);

  Stream get stream => _dailyProteinList.stream;

  List<DailyProtein> get currentList => _dailyProteinList.value;

  DailyProteinService() {
    _getAllDailyProtein();
  }
  void _getAllDailyProtein() async {
    dbProteins = await _dailyProteinRepository.getAllDailyProteins();
    _dailyProteinList.add(dbProteins ?? []);
  }

  getMonthlyProtein(DateTime date) async {
    // var month = currentDate.month;
    final DateFormat formatter = DateFormat('MMMM');
    var monthName = formatter.format(currentDate);
    print("MONTH NAME: $monthName");

    List monthlyProteins =
        await _dailyProteinRepository.getAllDailyProteins(query: monthName);
    print("dailyProteins from db from $monthName");
    monthlyProteins.forEach((p) => print("${p.name}"));
    return monthlyProteins;
  }

  add(DailyProtein dailyProtein) async {
    _dailyProteinList.value.add(dailyProtein);
    _dailyProteinList.add(List<DailyProtein>.from(currentList));

    _dailyProteinRepository.insertDailyProtein(dailyProtein);

    _getAllDailyProtein();
  }

  update(DailyProtein dailyProtein) async {
    await _dailyProteinRepository.updateDailyProtein(dailyProtein);
    List<DailyProtein> dailyProteins =
        await _dailyProteinRepository.getAllDailyProteins();
    dailyProteins.forEach((element) {
      print(element.date);
      print(element.totalProtein);
      print(element.goal);
    });
    _getAllDailyProtein();
  }

  remove(int id) async {
    _dailyProteinList.value
        .removeWhere((dailyProtein) => dailyProtein.id == id);
    _dailyProteinList.add(List<DailyProtein>.from(currentList));
    await _dailyProteinRepository.deleteDailyProteinById(id);
    _getAllDailyProtein();
  }

  getDailyProteinId(DailyProtein dailyProtein) async {
    int id = await _dailyProteinRepository.getDailyProteinId(dailyProtein);
    return id;
  }

  getDailyProteinIdByDate(String date) async {
    int id = await _dailyProteinRepository.getDailyProteinIdByDate(date);
    return id;
  }
}

DailyProteinService dailyProteinServices = DailyProteinService();
