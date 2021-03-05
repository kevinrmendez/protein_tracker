import 'package:hive/hive.dart';

part 'protein_entity.g.dart';

@HiveType(typeId: 1)
class ProteinEntity extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int amount;
  @HiveField(3)
  final String date;

  ProteinEntity({this.id, this.name, this.amount, this.date});

  @override
  int get hashCode =>
      name.hashCode ^ amount.hashCode ^ date.hashCode ^ id.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProteinEntity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          amount == other.amount &&
          date == other.date &&
          id == other.id;

  static ProteinEntity fromJson(Map<String, dynamic> data) => ProteinEntity(
      id: data['id'] as String,
      name: data['name'] as String,
      amount: data['amount'] as int,
      date: data['date'] as String);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "amount": amount,
        "date": date,
      };
}
