import 'package:protein_tracker/infrastructure/proteins/protein_entity.dart';

abstract class IProteinRepository {
  Future<List<ProteinEntity>> getAllProteins();
  void insertProtein(ProteinEntity protein);
  void updateProtein(ProteinEntity protein);
  void deleteProteinById(ProteinEntity protein);
  //We are not going to use this in the demo
  // Future deleteAllFoods() => foodDao.deleteAllFoods();
}
