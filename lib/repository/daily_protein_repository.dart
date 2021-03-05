import 'package:protein_tracker/dao/daily_protein_dao.dart';
import 'package:protein_tracker/domain/dailyProtein.dart';

class DailyProteinRepository {
  final dailyProteinDao = DailyProteinDao();

  Future getAllDailyProteins({String query}) =>
      dailyProteinDao.getDailyProtein(query: query);

  Future getDailyProteinId(DailyProtein dailyProtein) =>
      dailyProteinDao.getDailyDailyProteinId(dailyProtein);
  Future getDailyProteinIdByDate(String date) =>
      dailyProteinDao.getDailyDailyProteinIdByDate(date);

  Future insertDailyProtein(DailyProtein dailyProtein) =>
      dailyProteinDao.createDailyProtein(dailyProtein);

  Future updateDailyProtein(DailyProtein dailyProtein) =>
      dailyProteinDao.updateDailyProtein(dailyProtein);

  Future deleteDailyProteinById(int id) =>
      dailyProteinDao.deleteDailyProtein(id);

  Future deleteAllDailyProteins() => dailyProteinDao.deleteAllDailyProteins();
}
