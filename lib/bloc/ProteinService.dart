import 'package:protein_tracker/model/protein.dart';
import 'package:protein_tracker/repository/protein_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProteinService {
  static List<Protein> dbProteins = [];
  final ProteinRepository _proteinRepository = ProteinRepository();

  ProteinService() {
    _getProtein();
  }
  void _getProtein() async {
    dbProteins = await _proteinRepository.getAllProteins();
    _proteinList.add(dbProteins);
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

  remove(int index) {
    _proteinList.value.removeAt(index);
    _proteinList.add(List<Protein>.from(currentList));
  }
}

ProteinService proteinListServices = ProteinService();
