import 'package:intl/intl.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/model/dailyProtein.dart';
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
    _getDailyProtein();
  }
  void _getDailyProtein() async {
    dbProteins = await _dailyProteinRepository.getAllDailyProteins();
    _dailyProteinList.add(dbProteins ?? []);
  }

  getMonthlyProtein(DateTime date) async {
    // var month = currentDate.month;
    final DateFormat formatter = DateFormat('MMMM');
    var monthName = formatter.format(currentDate);
    print("MONTH NAME: $monthName");
    formattedDateNow = formatter.format(date);

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

    _getDailyProtein();
  }

  update(DailyProtein dailyProtein) async {
    await _dailyProteinRepository.updateDailyProtein(dailyProtein);
    _getDailyProtein();
  }

  remove(int id) async {
    _dailyProteinList.value
        .removeWhere((dailyProtein) => dailyProtein.id == id);
    _dailyProteinList.add(List<DailyProtein>.from(currentList));
    await _dailyProteinRepository.deleteDailyProteinById(id);
    _getDailyProtein();
  }

  getDailyProteinId(DailyProtein dailyProtein) async {
    int id = await _dailyProteinRepository.getDailyProteinId(dailyProtein);
    return id;
  }

  // void orderFoodsAscending() {
  //   List<DailyProtein> orderList = currentList;
  //   orderList.sort((a, b) => a.date.compareTo(b.date));
  //   _dailyProteinList.add(orderList);
  // }

  // void orderFoodsDescending() {
  //   List<DailyProtein> orderList = currentList;
  //   orderList.sort((a, b) => a.date.compareTo(b.date));
  //   List<DailyProtein> reversedList = orderList.reversed.toList();
  //   _dailyProteinList.add(reversedList);
  // }
}

DailyProteinService dailyProteinListServices = DailyProteinService();
