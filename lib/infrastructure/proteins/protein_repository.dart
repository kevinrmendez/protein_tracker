import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:protein_tracker/dao/protein_dao.dart';
import 'package:protein_tracker/infrastructure/proteins/protein_entity.dart';
import 'package:protein_tracker/domain/proteins/i_proteins_repository.dart';

@LazySingleton()
@Injectable(as: IProteinRepository)
class ProteinRepository implements IProteinRepository {
  final proteinDao = ProteinDao();

  @override
  Future<List<ProteinEntity>> getAllProteins({String query}) {
    final Box<ProteinEntity> box = Hive.box('proteinEntity');
    print("BOX PROTEINS: VALUES");
    box.values.forEach((element) {
      print(element.name);
    });
    return Future.value(box.values.toList());
  }

  @override
  void insertProtein(ProteinEntity protein) {
    final Box<ProteinEntity> box = Hive.box<ProteinEntity>('proteinEntity');

    box.put(protein.id, protein);
  }

  @override
  void updateProtein(ProteinEntity protein) async {
    final Box<ProteinEntity> box = Hive.box<ProteinEntity>('proteinEntity');
    await box.put(protein.id, protein);
  }

  @override
  void deleteProteinById(ProteinEntity proteinEntity) async {
    final Box<ProteinEntity> box = Hive.box<ProteinEntity>('proteinEntity');
    await box.delete(proteinEntity.id);
  }

  //We are not going to use this in the demo
  // Future deleteAllProteins() => proteinDao.deleteAllProteins();
}
