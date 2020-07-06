import 'package:protein_tracker/model/protein.dart';
import 'package:rxdart/rxdart.dart';

class ProteinService {
  BehaviorSubject<List<Protein>> _proteinList =
      BehaviorSubject.seeded(<Protein>[]);

  Stream get stream => _proteinList.stream;

  List<Protein> get currentList => _proteinList.value;

  add(Protein protein) {
    _proteinList.value.add(protein);
    _proteinList.add(List<Protein>.from(currentList));
  }

  remove(int index) {
    _proteinList.value.removeAt(index);
    _proteinList.add(List<Protein>.from(currentList));
  }
}

ProteinService proteinListServices = ProteinService();
