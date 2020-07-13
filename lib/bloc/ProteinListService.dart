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
    //TODO: FIX PROTEIN UPDATE
    print("PROTEIN ID:${protein.id}");
    _proteinRepository.updateProtein(protein);
    _getProtein();
  }

  remove(int index) {
    _proteinList.value.removeAt(index);
    _proteinList.add(List<Protein>.from(currentList));
  }
}

ProteinListService proteinListServices = ProteinListService();
