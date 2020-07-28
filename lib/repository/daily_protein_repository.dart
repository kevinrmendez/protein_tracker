import 'package:protein_tracker/dao/daily_protein_dao.dart';
import 'package:protein_tracker/model/dailyProtein.dart';

class DailyProteinRepository {
  final dailyProteinDao = DailyProteinDao();

  Future getAllDailyProteins({String query}) =>
      dailyProteinDao.getDailyProtein(query: query);

  Future getDailyProteinId(DailyProtein dailyProtein) =>
      dailyProteinDao.getDailyDailyProteinId(dailyProtein);

  Future insertProtein(DailyProtein dailyProtein) =>
      dailyProteinDao.createDailyProtein(dailyProtein);

  Future updateProtein(DailyProtein dailyProtein) =>
      dailyProteinDao.updateDailyProtein(dailyProtein);

  Future deleteProteinById(int id) => dailyProteinDao.deleteDailyProtein(id);

  Future deleteAllDailyProteins() => dailyProteinDao.deleteAllDailyProteins();
}
