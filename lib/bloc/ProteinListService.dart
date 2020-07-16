import 'package:intl/intl.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/model/protein.dart';
import 'package:protein_tracker/repository/protein_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProteinListService {
  static List<Protein> dbProteins = [];
  final ProteinRepository _proteinRepository = ProteinRepository();

  ProteinListService() {
    _getProtein();
  }
  void _getProtein() async {
    var date = formattedDateNow;
    dbProteins = await _proteinRepository.getAllProteins(
      query: date,
    );
    print("DBPROTEIN $dbProteins");
    var dbProtein2 = await _proteinRepository.getAllProteins();
    print("DBPROTEIN2: $dbProtein2");
    dbProteins.forEach((p) => print(p.name));
    _proteinList.add(dbProteins ?? []);
  }

  getMonthlyProtein(DateTime date) async {
    // var month = currentDate.month;
    final DateFormat formatter = DateFormat('MMMM');
    var monthName = formatter.format(currentDate);
    print("MONTH NAME: $monthName");
    formattedDateNow = formatter.format(date);

    List monthlyProteins =
        await _proteinRepository.getAllProteins(query: monthName);
    print("proteins from db from $monthName");
    monthlyProteins.forEach((p) => p.name);
    return monthlyProteins;
  }

  BehaviorSubject<List<Protein>> _proteinList =
      BehaviorSubject.seeded(<Protein>[]);

  Stream get stream => _proteinList.stream;

  List<Protein> get currentList => _proteinList.value;

  add(Protein protein) async {
    _proteinList.value.add(protein);
    _proteinList.add(List<Protein>.from(currentList));

    _proteinRepository.insertProtein(protein);
    var proteins = await _proteinRepository.getAllProteins();
    proteins.forEach((f) => print(f.name));
  }

  update(Protein protein) async {
    await _proteinRepository.updateProtein(protein);
  }

  remove(int id) async {
    _proteinList.value.removeWhere((protein) => protein.id == id);
    _proteinList.add(List<Protein>.from(currentList));
    await _proteinRepository.deleteProteinById(id);
    // _getProtein();
  }

  getProteinId(Protein protein) async {
    int id = await _proteinRepository.getProteinId(protein);
    return id;
  }
}

ProteinListService proteinListServices = ProteinListService();
