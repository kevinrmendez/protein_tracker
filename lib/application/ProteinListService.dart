import 'package:intl/intl.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/domain/proteins/protein.dart';
import 'package:protein_tracker/infrastructure/proteins/protein_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProteinListService {
  static List<Protein> dbProteins = [];
  final ProteinRepository _proteinRepository = ProteinRepository();

  BehaviorSubject<List<Protein>> _proteinList =
      BehaviorSubject.seeded(<Protein>[]);

  Stream get stream => _proteinList.stream;

  List<Protein> get currentList => _proteinList.value;

  ProteinListService() {
    // _getProtein();
  }
//   void _getProtein() async {
//     var dateNow = DateTime.now();
//     final DateFormat formatter = DateFormat('dd-MMMM-yyyy');
//     var formattedDate = formatter.format(dateNow);
//     var date = formattedDate;
//     dbProteins = await _proteinRepository.getAllProteins(
//       query: date,
//     );
//     print("DBPROTEIN $dbProteins");
//     var dbProtein2 = await _proteinRepository.getAllProteins();
//     print("DBPROTEIN2: $dbProtein2");
//     dbProteins.forEach((p) => print(p.name));
//     _proteinList.add(dbProteins ?? []);

// //reset Protein Consumed on date change during app use
//     print("FormattedDayCache: $formattedDayCache");
//     if (formattedDate != formattedDayCache) {
//       resetState();
//       formattedDayCache = formattedDate;
//     }
//   }

  getMonthlyProtein(DateTime date) async {
    // var month = currentDate.month;
    final DateFormat formatter = DateFormat('MMMM');
    var monthName = formatter.format(currentDate);
    print("MONTH NAME: $monthName");

    List monthlyProteins =
        await _proteinRepository.getAllProteins(query: monthName);
    print("proteins from db from $monthName");
    monthlyProteins.forEach((p) => print("${p.name}"));
    return monthlyProteins;
  }

//   add(Protein protein) async {
//     _proteinList.value.add(protein);
//     _proteinList.add(List<Protein>.from(currentList));

//     // _proteinRepository.insertProtein(protein);
// //TODO:FIX ADD REMOVE, UPDATE PROTEIN LIST WHEN 2 DIFFERENT DAYS ARE SHOWNED

//     _getProtein();
//   }

  // update(Protein protein) async {
  //   await _proteinRepository.updateProtein(protein);
  //   // _getProtein();
  // }

  // remove(int id) async {
  //   _proteinList.value.removeWhere((protein) => protein.id == id);
  //   _proteinList.add(List<Protein>.from(currentList));
  //   await _proteinRepository.deleteProteinById(id);
  //   _getProtein();
  // }

  // getProteinId(Protein protein) async {
  //   int id = await _proteinRepository.getProteinId(protein);
  //   return id;
  // }

  void orderFoodsAscending() {
    List<Protein> orderList = currentList;
    orderList.sort((a, b) => a.name.compareTo(b.name));
    _proteinList.add(orderList);
  }

  void orderFoodsDescending() {
    List<Protein> orderList = currentList;
    orderList.sort((a, b) => a.name.compareTo(b.name));
    List<Protein> reversedList = orderList.reversed.toList();
    _proteinList.add(reversedList);
  }
}

ProteinListService proteinListServices = ProteinListService();
