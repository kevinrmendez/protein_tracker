import 'package:injectable/injectable.dart';
import 'package:protein_tracker/dao/protein_dao.dart';
import 'package:protein_tracker/model/protein.dart';
import 'package:protein_tracker/model/protein_entity.dart';

@LazySingleton()
class ProteinRepository {
  final proteinDao = ProteinDao();

  Future getAllProteins({String query}) => proteinDao.getprotein(query: query);

  Future getProteinId(Protein protein) => proteinDao.getProteinId(protein);

  Future insertProtein(ProteinEntity protein) =>
      proteinDao.createProtein(protein);

  Future updateProtein(Protein protein) => proteinDao.updateProtein(protein);

  Future deleteProteinById(ProteinEntity protein) =>
      proteinDao.deleteProtein(protein);

  //We are not going to use this in the demo
  Future deleteAllProteins() => proteinDao.deleteAllProteins();
}
